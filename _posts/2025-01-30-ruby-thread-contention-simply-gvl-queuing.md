---
title: "Ruby \"Thread Contention\" is simply GVL Queuing"
date: 2025-01-30 14:43 PST
published: true
tags: 
  - Ruby
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "9b167902813f5874"
  vector: "9vYBBP34+vgIA/8L+Pr8/RT18gcF/f8B/fj9/AX4/foFB/kC/ff6BQEA8v74BwX/+/T3BP/+AgEN+PkD/fv6AQ3+DQUC/QkB9QT+/gD6Av0CAgYAAfn+BAYAAgQCCw8JBwX7/wUABQIDBP8N9fUNAgkF/AUOAgUIAgn7+f8B/AAE/fT79wX7/AH8A/0AA/v6AQABCAf7+AL9BAP29QMBAP0FBgL+/gP4AAHzA/z+9wP1/gwDCgj//w8AABEJAPsKBPsABPsK+QT/AQT7A/v5Af0F+fn6+gX3+gD9/gr/AQAA8foVBwEA+fb7+/3/DQ77CPwBAAb+BfsK+ff8Af4B/wYA/Q3+BgP9Cfn9/foN+Pn7BQUFBQ4D+/sAAwQDAQT5BPwL9gP+AwYAA/4O/Pn4//QHAAn9AQYG/fwC/QD8+AAMAPwCCwEAAvwQEP4CAQsD+Pj/+wAA+gj0AAUAA/EBBP4A+AH1AwsA+/4IAwT88/36AfYC/gz7BAj1/gIF+vX+"
---

There’s been a ton of fantastic posts from Jean Boussier recently explaining [application shapes](https://byroot.github.io/ruby/performance/2025/01/23/the-mythical-io-bound-rails-app.html), [instrumenting the GVL (Global VM Lock)](https://byroot.github.io/ruby/performance/2025/01/23/the-mythical-io-bound-rails-app.html), and [thoughts on removing the GVL](https://byroot.github.io/ruby/performance/2025/01/29/so-you-want-to-remove-the-gvl.html). They’re great reads!

For the longest time, I’ve misunderstood the phrase “thread contention”. It’s a little embarrassing that given I’m the author of GoodJob (👍) and a maintainer of Concurrent Ruby and have been doing Ruby and Rails stuff for more than a decade. But true.

I’ve been reading about thread contention for quite a while.
- I was probably initially introduced to thread contention in Nate Berkopec’s [Speedshop blog](https://www.speedshop.co/2020/05/11/the-ruby-gvl-and-scaling.html).
- Thread contention came to the front of my mind from Maciej Mensfeld’s post about the [problems with Thread.pass](https://mensfeld.pl/2022/01/reduce-your-method-calls-by-99-9-by-replacing-threadpass-with-queuepop/)
- The hot discussion about Rail’s [default puma thread count](https://github.com/rails/rails/issues/50450).
- Ivo Anjo did a [fantastic deep dive into the GVL](https://ivoanjo.me/blog/2023/07/23/understanding-the-ruby-global-vm-lock-by-observing-it/).

Through all of this, I perceived thread contention as _contention_: a struggle, a bunch of threads all elbowing each other to run and stomping all over each other in a an inefficient, disagreeable, disorganized dogpile. But that’s not what happens at all!

Instead: when you have any number of threads in Ruby, each thread waits in an orderly queue to be handed the Ruby GVL, then they gently hold the GVL until they graciously give it up or it’s politely taken from them, and then the thread goes to the back of the queue, where they patiently wait again.

That’s what “thread contention” is in Ruby: in-order queuing for the GVL. It’s not that wild.

### Let’s go deeper

I came to this realization when [researching whether I should reduce GoodJob’s thread priority](https://github.com/bensheldon/good_job/issues/1554) (I did). This came up after some exploration at GitHub, my day job, where we have a maintenance background thread that would occasionally blow out our performance target for a particular web request if the background thread happened to run at the same time that the web server (Unicorn) was responding to the web request.

Ruby threads are OS (operating system) threads. And OS threads are preemptive, meaning the OS is responsible for switching CPU execution among active threads. But, Ruby controls its GVL. Ruby itself takes a strong role in determining which threads are active for the OS by choosing which Ruby thread to hand the GVL to and when to take it back.

(Aside: Ruby 3.3 introduced M:N threads which decouples how Ruby threads map to OS threads, but ignore that wrinkle here.)

There’s a very good C-level explanation of what happens inside the Ruby VM in [The Ruby Hacking Guide](https://ruby-hacking-guide.github.io/thread.html). But I’ll do my best to explain briefly here:

When you create a Ruby thread (`Thread.new`), that thread goes into the back of a queue in the Ruby VM. The thread waits until the threads ahead of it in the queue have their chance to use the GVL.

When the thread gets to the front of the queue and gets the GVL, the thread will start running its Ruby code until it gives up the GVL. That can happen for one of two reasons:

- When the thread goes from executing Ruby to doing IO, it releases the GVL (usually; it’s mostly considered a bug in the IO library if it doesn’t). When the thread is done with its IO operation, the Thread goes to the back of the queue.
- When the thread has been executing for longer than the length of the thread “quantum”, the Ruby VM takes back the GVL and the thread steps to the back of the queue again. The Ruby thread quantum default is 100ms (this is configurable via `Thread#priority` or [directly as of Ruby 3.4](https://bugs.ruby-lang.org/issues/20861)).

That second scenario is rather interesting. When a Ruby thread starts running, the Ruby VM uses yet another background thread (at the VM level) that sleeps for 10ms (the “tick”) and then checks how long the Ruby thread has been running for. If the thread has been running for longer then the length of the quantum, the Ruby VM takes back the GVL from the active thread (“preemption”) and gives the GVL to the next thread waiting in the GVL queue. The thread that was previously executing now goes to the back of the queue. In other words: the thread quantum determines how quickly threads shuffle through the queue and no less/faster than the tick.

That’s it! That’s what happens with Ruby thread contention. It’s all very orderly, it just might take longer than expected or desired.

### What’s the problem

The dreaded "Tail Latency" of multithreaded behavior can happen, related to the Ruby Thread Quantum, when you have what might otherwise be a very short request, for example:

* A request that could be 10ms because it's making ten 1ms calls to Memcached/Redis to fetch some cached values and then returns them (IO-bound Thread)

⠀...but when it's running in a thread next to:

* A request that takes 1,000ms and largely spends its time doing string manipulation, for example a background thread that is taking a bunch of complex hashes and arrays and serializing them into a payload to send to a metrics server. Or rendering slow/big/complex views for Turbo Broadcasts (CPU-bound Thread)

In this scenario, the CPU-bound thread will be very greedy with holding the GVL and it will look like this:

1. IO-bound Thread: Starts 1ms network request and releases GVL
2. CPU-bound Thread: Does 100ms of work on the CPU before the GVL is taken back
3. IO-bound Thread: Gets GVL again and starts next 1ms network request and releases GVL
4. CPU-bound Thread: Does 100ms of work on the CPU before the GVL is taken back
5. Repeat … 8 more times…
6. Now 1,000 ms later, the IO-bound Thread, which ideally would have taken 10ms is finally done. That’s not good!

That’s the worse case in this simple scenario with only two threads. With more threads of different workloads, you have the potential to have even more of a problem. Ivo Anjo also [wrote about this too](https://ivoanjo.me/blog/2023/02/11/ruby-unexpected-io-vs-cpu-unfairness/). You could speed this up by lowering overall thread quantum, or by reducing the priority of the CPU-bound thread (which lowers the thread quantum). This would cause the CPU-bound thread to be more finely sliced, but because the minimum slice is governed by the tick (10ms) you'd never get below a theoretical maximum of 100ms for the IO-bound thread; 10x more than optimal.
