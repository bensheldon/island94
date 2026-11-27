---
title: "Converting a Ruby block interface to start/stop methods with a Fiber"
date: 2026-09-05 12:00 UTC
published: true
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "100b3441668fdb19"
  vector: "9vv9Cf8B//v4/QAN+gIGAQ/9BAQOBw7/9/b5+wv6EPz5AAgOBPbzAw788QT79v36//n7+wH6DP4K/QQCAf31/QIEAA8EAAD//gwFAQMB8Pr49gP9/AUH/wz7/AX/BAgA/fn+AwQAAfcC+vkI+vcD/wYHAQUGBQkLEAYGAv72AgAF+fUH/v3/AfwE/wD3BP35AwwHBAAC/Ab8//76BAMBAf0MAQL/Aff6/gD4/v7v+QP7AgoHB/779f4KBfoD+vcCAf/9+wEI9gb2CAH8+gP4AwIG+fz1/wb6+Pz6/QP7BgAO/P8HBfYKAP39/foEAQT+//gFCvMBBv4CB/r//PsF+v/98hD3CQUAFP78/f36/fHy/AIHBvgG+QcA+f8HAgL7A/wE9v/7CQ4BAv0H/P39CO0C/gb+AgAFA/kCAQUIAgD//voLAwL//gAEAgIHBf7/BQP7/f4A/Aj4AgEBCfsI+P0M9wj2BwgMA/7+//7+8gL0B/r/9wYG+wj7+QT39wAE"
---

One of the small joys of computer programming is reading some code and thinking _aha, that’s nice_.

I recently encountered this feeling of _aha_ while reading the docs for the [`playwright-ruby-client`](https://github.com/YusukeIwaki/playwright-ruby-client)’s set up code for Capybara [which described a mismatch between the Playwright and RSpec interface](https://playwright-ruby-client.vercel.app/docs/article/guides/rails_integration_with_null_driver):

> The challenge is that `Playwright.create` and `playwright.chromium.launch` are block-scoped APIs — the browser shuts down when the block exits. RSpec has `before(:suite)` and `after(:suite)` but no `around(:suite)`. A Fiber bridges the gap: `start!` resumes the fiber until it yields the browser back, and `stop!` resumes it again so both blocks exit cleanly.

I’ll get to *that* code in a moment, but to set up the explanation: I have written _a lot_ of code that converts `start`- and `stop`-like methods into a block interface. That looks something like this:

```ruby
def with_resource
  resource = ResourceLibrary.start!
  yield resource
ensure
  ResourceLibrary.stop!
end

# and then used it like
with_resource do |resource|
  my_code_does_stuff_with resource
end
```

…but I can’t remember a time when I’ve gone the other way: when a library only provides a block-style interface and I needed to convert it to distinct start and stop methods.

If I hadn’t seen this `playwright-ruby-client` documentation, I’d have probably imagined doing it with a Thread and Queues to smuggle the resource out of a block. Something like this:

```ruby
class ThreadedResourceWrapper
  attr_reader :resource

  def initialize
    @control_queue = Queue.new
    @resource_queue = Queue.new
  end

  def start!
    @thread = Thread.new do
      ResourceLibrary.open do |the_resource|
        @resource_queue.push(the_resource)
        @control_queue.pop # Pause the thread
      end
    end

    @resource = @resource_queue.pop # Smuggle out the resource
  end

  def stop!
    @control_queue.push(:stop) # Resume the thread to end the block
    @thread.join
    @resource = nil
  end
end
```

Instead, I’m impressed with using a simple Fiber (blocking, no scheduler) to effectively do the same thing, but without the (slight) overhead of a separate thread:

```ruby
class FiberResourceWrapper
  attr_reader :resource

  def start
    @fiber = Fiber.new do
      ResourceLibrary.open do |the_resource|
        Fiber.yield the_resource
      end
    end

    @resource = @fiber.resume # Resume #1: Run the fiber to smuggle out the resource
  end

  def stop
    @fiber.resume # Resume #2: resume the fiber to end the block
    @resource = nil
  end
end
```

Of light commentary: The usage of two `Queue` objects in the `ThreadedResourceWrapper` is slightly complicated for managing the execution flow… and I also find the Fiber `resume` behavior to be slightly confusing (or at least require _extra attention_) because a Fiber has to be explicitly `resume`’d after initialization to run at all, unlike a Thread which starts executing immediately (well, implicitly but concurrently)

And lastly, for fun, I imagined how I might use this new Fiber knowledge to patch an `around_suite` callback into RSpec so I didn’t have to wrap every individual resource:

```ruby
module RSpecAroundSuite
  def around_suite(&block)
    fiber = nil

    RSpec.configure do |config|
      config.before(:suite) do
        fiber = Fiber.new do
          run_suite = -> { Fiber.yield }
          run_suite.define_singleton_method(:run) { call } # allow `suite.run` to be analogous to `example.run`

          block.call(run_suite)
        end

        fiber.resume
      end

      config.after(:suite) do
        fiber.resume
      end
    end
  end
end

RSpec.extend(RSpecAroundSuite)

RSpec.around_suite do |suite|
  ResourceLibrary.open do |the_resource|
    $resource = the_resource # assign it to somewhere accessible
    suite.run
  end
end
```
