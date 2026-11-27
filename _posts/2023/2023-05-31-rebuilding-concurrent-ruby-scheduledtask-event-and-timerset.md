---
title: "Rebuilding Concurrent Ruby: ScheduledTask, Event, and TimerSet"
date: 2023-05-31 18:44 PDT
published: true
tags: [ruby, GoodJob]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "66df1f28d649de9b"
  vector: "9Pn7BP4AAPoIA/wH///9+Q/89wEIAAgK8/gD9wEBAPIAAAEHAvn6/gH68/71A/sA+/j7AAH4DQYN+vz8APj6AAkC/QUK+PwG+wf5/gn58v/2+QACBPcDBQkB/wYEBgsHBwf8AAT+AfsE/vb/+PQN+A0EAAgHCAwICwv99QYCBQAB/fH7/QH6AQD9BPr7Afz4CAMHBQX99wgB/AD6+gP8CvcDBAD+BAT1AP30AQLy+QcE/w/8C/v7/gcA/wkI//0GBP8C/QMF/Q3+Av//Bvr1BwUB9/76AgAC+fv8+gUCAQAJ8/oKDQAA9PP49/35Awr3CQL9Bf4B+P8K/vj/AQH/+QgC/QcCAAT8E////v0N+vvyBQH8AAoC9f/3AQUB/gwGBQID8wIBDQv5APsK+f71AvYABAj7CgQHAf0B+/8D+QALAfwEAf0E+P8GB/sLAwj/BAD/+wj+AAH5BP4GDfgB/P4I+gD5/gb/Av36BgT69Pv6B/IJ/wgABw7y/AUE//b/"
---

I’ve been diving into [Concurrent Ruby library](https://github.com/ruby-concurrency/concurrent-ruby) a lot recently. I use Concurrent Ruby as the foundation for [GoodJob](https://github.com/bensheldon/good_job) where it has saved me immense time and grief because it has a lot of reliable, complex thread-safe primitives that are well-shaped for GoodJob’s needs. I’m a big fan of Concurrent Ruby.

I wanted to cement some of my learnings and understandings by writing a quick blog post to explain how some parts of Concurrent Ruby work, in the spirit of Noah Gibb's [_Rebuilding Rails_](https://rebuilding-rails.com/). In the following, I’ll be sharing runnable Ruby code that is similar to how Concurrent Ruby solves the same kind of problems. That said, **Concurrent Ruby is much, much safer—and thus a little more complex—than what I’m writing here** so please, if you need this functionality, use Concurrent Ruby directly.

### The use case: future scheduled tasks

Imagine you want to run some bits of code, at a point in time in the future. It might look like this example creating several tasks at once with varying delays in seconds:

```ruby
ScheduledTask.execute(delay = 30) do
  # run some code
end

ScheduledTask.execute(60) do
  # run some code
end

ScheduledTask.execute(15) do
  # run some code
end
```

In Concurrent Ruby, the object to do this is a [`Concurrent::ScheduledTask`](https://ruby-concurrency.github.io/concurrent-ruby/1.2.0/Concurrent/ScheduledTask.html ) (good name, right?). A ScheduledTask will wait `delay` seconds and then run the block of code on a background thread.

Behind the ScheduledTask is the real star: the [`Concurrent::TimerSet`](https://ruby-concurrency.github.io/concurrent-ruby/1.2.0/Concurrent/TimerSet.html), which executes a collection of tasks, each after a given delay. Let’s break down the components of a TimerSet:

- TimerSet maintains a list of tasks, ordered by their delays, with the soonest first
- TimerSet runs a reactor-like loop in a background thread. This thread will peek at the next occurring task and wait/sleep until it occurs, then pop the task to execute it.
- TimerSet uses a `Concurrent::Event` (which is like a `Mutex` and `ConditionVariable` combined in a convenient package) to interrupt the sleeping reactor when new tasks are created.

I’ll give examples of each of these. But first, you may be asking….

## Why is this so hard?

This is a lot of objects working together to accomplish the use case. This is why:

- Ruby threads have a cost, so we can’t simply create a new thread for each and every task, putting it to sleep until an individual task is intended to be triggered. That would be a lot of threads.
- Ruby threads [aren't safe be canceled/killed](http://headius.blogspot.com/2008/02/rubys-threadraise-threadkill-timeoutrb.html), so we can’t, for example, create a single thread for the soonest task but then terminate it and create a new thread if new task is created with a sooner time.

The following section will show how these objects are put together. Again, this is not the exact Concurrent Ruby implementation, but it’s the general shape of how Concurrent Ruby solves this use case.

## The `Event`

Concurrent Ruby describes a [`Concurrent::Event`](https://github.com/ruby-concurrency/concurrent-ruby/blob/9f40827be9a8a192a6993a8d157bd3ed0662ada0/lib/concurrent-ruby/concurrent/atomic/event.rb) as:

>  Old school kernel-style event reminiscent of Win32 programming in C++.

I don’t know what that means exactly, but an Event can be in either a set or unset state, and it can wait (with a timeout!) and be awakened via signals across threads.

I earlier described `Event` as a `Mutex` and `ConditionVariable` packaged together. The `ConditionVariable`is the star here, and the mutex is simply a supporting actor because the ConditionVariable requires it.  

A [Ruby `ConditionVariable`](https://docs.ruby-lang.org/en/3.2/Thread/ConditionVariable.html) has two features that are perfect for multithreaded programming:

- `wait`, which is blocking and will put a thread to sleep, with an optional timeout
- `set`, which broadcasts a signal to any waiting threads to wake up.

Jesse Storimer's excellent and free ebook _Working with Ruby Threads_ has a great [section on ConditionVariables](https://workingwithruby.com/wwrt/condvars/) and why the mutex is a necessary part of the implementation.

Here's some code that implements an Event with an example to show how it can wake up a thread:

```ruby
class Event
  def initialize
    @mutex = Mutex.new
    @condition = ConditionVariable.new
    @set = false
  end

  def wait(timeout)
    @mutex.synchronize do
      @set || @condition.wait(@mutex, timeout)
    end
  end

  def set
    @mutex.synchronize do
      @set = true
      @condition.broadcast
    end
  end

  def reset
    @mutex.synchronize do
      @set = false
    end
  end
end
```

Here’s a simple example of an Event running in a loop to show how it might be used:

```ruby
event = Event.new
running = true
thread = Thread.new do
  # A simple loop in a thread
  while running do
    # loop every second unless signaled
    if event.wait(1)
      puts "Event has been set"
      event.reset
    end
  end
  puts "Exiting thread"
end

sleep 1
event.set
#=> Event has been set

sleep 1
event.set
#=> Event has been set

# let the thread exit
running = false
thread.join
#=> Exiting thread

```

### The `ScheduledTask`

The implementation of the ScheduledTask isn’t too important in this explanation, but I’ll sketch out the necessary pieces, which match up with a [`Concurrent::ScheduledTask`](https://github.com/ruby-concurrency/concurrent-ruby/blob/9f40827be9a8a192a6993a8d157bd3ed0662ada0/lib/concurrent-ruby/concurrent/scheduled_task.rb):

```ruby
# GLOBAL_TIMER_SET = TimerSet.new

class ScheduledTask
  attr_reader :schedule_time

  def self.execute(delay, timer_set: GLOBAL_TIMER_SET, &task)
    scheduled_task = new(delay, &task)
    timer_set.post_task(scheduled_task)
  end

  def initialize(delay, &task)
    @schedule_time = Time.now + delay
    @task = task
  end

  def run
    @task.call
  end

  def <=>(other)
    schedule_time <=> other.schedule_time
  end
end
```

A couple things to call out here:

- The `GLOBAL_TIMER_SET` is necessary so that all ScheduledTasks are added to the same TimerSet. In Concurrent Ruby, this is `Concurrent.global_timer_set`, though a `ScheduledTask.execute` can be given an explicit `timer_set:` parameter if an application has multiple TimerSets (for example, GoodJob initializes its own TimerSet for finer lifecycle management).
- The `<=>` comparison operator, which will be used to keep our list of tasks sorted with the soonest tasks first.

### The `TimerSet`

Now we have the pieces necessary to implement a TimerSet and fulfill our use case. The TimerSet implemented here is very similar to a [`Concurrent::TimerSet`](https://github.com/ruby-concurrency/concurrent-ruby/blob/9f40827be9a8a192a6993a8d157bd3ed0662ada0/lib/concurrent-ruby/concurrent/executor/timer_set.rb):

```ruby
class TimerSet
  def initialize
    @queue = []
    @mutex = Mutex.new
    @event = Event.new
    @thread = nil
  end

  def post_task(task)
    @mutex.synchronize do
      @queue << task
      @queue.sort!
      process_tasks if @queue.size == 1
    end
    @event.set
  end

  def shutdown
    @mutex.synchronize { @queue.clear }
    @event.set
    @thread.join if @thread
    true
  end

  private

  def process_tasks
    @thread = Thread.new do
      loop do
        # Peek the first item in the queue
        task = @mutex.synchronize { @event.reset; @queue.first }
        break unless task

        if task.schedule_time <= Time.now
          # Pop the first item in the queue
          task = @mutex.synchronize { @queue.shift }
          task.run
        else
          timeout = [task.schedule_time - Time.now, 60].min
          @event.wait(timeout)
        end
      end
    end
  end
end
```

There’s a lot going on here, but here are the landmarks:

- In this TimerSet, `@queue` is an `Array` that we explicitly call `sort!` on so that the soonest task is always first in the array. In the Concurrent Ruby implementation, that’s done more elegantly with a `Concurrent::Collection::NonConcurrentPriorityQueue`. The `@mutex` is used to make sure that adding/sorting/peeking/popping operations on the queue are synchronized and safe across threads.
- The magic happens in `#process_tasks`, which creates a new thread and starts up a loop. It loops over the first task in the queue (the soonest):
  - If there is no task, it breaks the loop and exits the thread.
  - If there is a task, it checks whether it’s time to run, and if so, runs it. If it’s not time yet, it uses the `Event#wait` until it _is_ time to run, or 60 seconds, whichever is sooner. That 60 seconds is a magic number in the real implementation, and I assume that’s to reduce clock drift. Remember, `Event#wait` is signalable, so if a new task is added, the loop will be immediately restarted and the delay recalculated.  
  - In real Concurrent Ruby, `task.run` is posted to a separate thread pool where it won’t block or slow down the loop.
- The `Event#set` is called inside of `#add_task` which inserts new tasks into the queue. The `process_tasks` background thread is only created _the first time_ a task is added to the queue after the queue has been emptied. This minimizes the number of active threads.
- The `Event#reset` is called when the queue is first peeked in `process_tasks`. There’s a lot of subtle race conditions being guarded against in a TimerSet. Calling reset unsets the event at the top of the loop to allow the Event to be set again before the `Event#wait`

And finally, we can put all of the pieces together to fulfill our use case of scheduled tasks:

```ruby
GLOBAL_TIMER_SET = TimerSet.new

ScheduledTask.execute(1) { puts "This is the first task" }
ScheduledTask.execute(5) { puts "This is the third task" }
ScheduledTask.execute(3) { puts "This is the second task" }

sleep 6
GLOBAL_TIMER_SET.shutdown

#=> This is the first task
#=> This is the second task
#=> This is the third task
```

### That’s it!

The TimerSet is a really neat object that’s powered by an Event, which is itself powered by a ConditionVariable. There’s a lot of fun thread-based signaling happening here!

While writing my post, I came across a 2014 post from Job Vranish entitled [“Ruby Queue Pop with Timeout”](https://spin.atomicobject.com/2014/07/07/ruby-queue-pop-timeout/), which builds something very similar looking using the same primitives. In the comments, Mike Perham linked to [Connection Pool’s TimedStack](https://github.com/mperham/connection_pool/blob/f83b6304c0e5936b1b286b26a73f3febda051c9b/lib/connection_pool/timed_stack.rb) which also looks similar. Again **please use a real library like Concurrent Ruby or Connection Pool.** This was just for explanatory purposes 👍
