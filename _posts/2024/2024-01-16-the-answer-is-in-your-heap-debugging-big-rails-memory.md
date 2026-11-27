---
title: "The answer is in your heap: debugging a big memory increase in Ruby on Rails"
date: 2024-01-16 14:41 PST
published: true
tags: [ruby, rails]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "50d809d17ff576da"
  vector: "9f7zDAb5AgX7BAEJ+/z8CAb3/AAKCP8H+vr8//7yCQr0AwkOAvr+AggK+gAA/gn/AfICCQD4AfoH9/kF/AT99vX8AP8HBP0D9gAEAQL9/Ov69QQEBf0E+QwDAwD/CAMACAb9DP4GBgYC/wMJ/f4FA/wHDgEH+/oFEAkFBff+/QAH/vUJ+gT7BQQI+gf7/wH8+Qr/AgQA8fcBCQAA/AIDAwEHBv8EAfXwAwL49/b3+w8EAgQIDgf39wECCwINAfoIBAAACQQI9wkEAATw/gD0AwP9+vf2AAz5+QH+/P77AAAG+QQHB/gIBfn4+/sD/Aj7+vcBBfYN/vn6AfoD+/gCBvz+8Qj8CgL7EQP1BAUF+gYFAQX7AAEEAQD9/AMC//b8//j+9wQBAAf+/AUE+v35Avb6/wX/APcO/AD//PsF9gD/BQEKBwMECP8CBQb3Af/5+/34/vv9/QX9/v4FCPsKBQAA+Aj8CAUF/AD8AQH/7v8E+/QB+An//QX2AAQG8fgF"
---

I recently participated in an [interesting series of debugging sessions](https://github.com/sciencehistory/scihist_digicoll/issues/2449) tracking down the source of a large increase in memory when upgrading a Rails application. We ultimately tracked down the cause using John Hawthorn’s [Sheap heap analyzer](https://github.com/jhawthorn/sheap) and successfully submitted a [patch to Rails](https://github.com/rails/rails/pull/50298). I thought it was interesting enough to write up because maybe the general approach to debugging memory issues would be helpful (and this is the kind of stuff that I very quickly forget unless I write it down).

### How it started: Reddit

Lots of people ask for help on r/rails, and it can be difficult to debug at a distance. [This time it was a little different](https://www.reddit.com/r/rails/comments/185b2wr/comment/kb1toyp/). I recognized the username’s owner, [Jonathan Rochkind](https://bibwild.wordpress.com), because he’s been a familiar and helpful face in GoodJob’s discussions and I've sponsored his aggregator [Rubyland News](https://rubyland.news/). The observed problem was that after upgrading from Rails 7.0 to Rails 7.1, their application’s memory footprint increased by about 25%. Weird!

### Working the problem

We worked through a bunch of questions:

* Was the memory increase at startup or over time? Not at boot, but memory increased very quickly.
* Did anything change with Puma configuration? Nope.
* Get set up with [`derailed_benchmarks`](https://github.com/zombocom/derailed_benchmarks), and create a `bin/profile` Rails binstub to make it easy to boot into a production-like configuration for profiling. Here’s what my very polished one looks like:

  ```ruby
  #!/usr/bin/env ruby

  # This file is a wrapper around the rails and derailed executables
  # to make it easier to boot in PRODUCTION mode.
  #
  # Usage: bin/profile [rails|derailed] [command]

  ENV["RAILS_ENV"] = ENV.fetch("RAILS_ENV", "production")
  ENV["RACK_ENV"] = "production"
  ENV["RAILS_LOG_TO_STDOUT"] = "true"
  ENV["RAILS_SERVE_STATIC_FILES"] = "true"
  ENV["FORCE_SSL"] = "false"
  ## ^^ Put ENV to boot in production mode here ^^

  executable = ARGV.shift
  if executable == "rails"
    load File.join(File.dirname(__FILE__), "rails")
  elsif executable == "derailed"
    require 'bundler/setup'
    load Gem.bin_path('derailed_benchmarks', 'derailed')
  else
    puts "ERROR: '#{executable}' is not a valid command."
    puts "Usage: bin/profile [rails|derailed]"
    exit 1
  end
  ```

We flailed around with Derailed Benchmarks, as well as John Hawthorn’s [Vernier profiler’s memory mode](https://github.com/jhawthorn/vernier?tab=readme-ov-file#retained-memory) (aside: John Hawthorn is doing amazing stuff with Ruby).

At this point, we had a general understanding of the application memory footprint, which involved a large number of model instances (`Work`), many of which contained a big blob of json. For some reason they were sticking around longer than a single web request, but we weren’t able to find any smoking guns of like, memoized class instance variables that were holding onto references. So we kept digging.

You can read along to all of this here: https://github.com/sciencehistory/scihist_digicoll/issues/2449

### Analyzing memory with Sheap

I used Derailed Benchmark’s [`perf:heap`](https://github.com/zombocom/derailed_benchmarks/blob/main/README.md#i-want-more-heap-dumps) to generate heap dumps (also possible using [`rbtrace --heapdump`](https://github.com/tmm1/rbtrace)), and then plugged those into Sheap. Sheap is a relatively new tool, and where it shines is being _interactive_. Instead of outputting a static report, Sheap allows for exploring a heap dump (or diff: to identify retained objects), and ask questions of the dump. In our case: *what objects are referencing this object and why is it being retained?*

```ruby
# $ irb
require './lib/sheap.rb

diff = Sheap::Diff.new("/Users/bensheldon/Repositories/sciencehistory/scihist_digicoll/tmp/2023-12-07T13:24:15-08:00-heap-1.ndjson", "/Users/bensheldon/Repositories/sciencehistory/scihist_digicoll/tmp/2023-12-07T13:24:15-08:00-heap-2.ndjson")

# Find one of the Work records that's been retained
model = diff.after.class_named("Work").first.instances[200]
=> <OBJECT 0x117cf5c98 Work (4 refs)>

# Find the path to the (default) root
diff.after.find_path(model)
=>
[<ROOT vm (2984 refs)>,
 <IMEMO 0x126c9ab68 callcache (1 refs)>,
 <IMEMO 0x126c9acf8 ment (4 refs)>,
 <CLASS 0x12197c080 (anonymous) (15 refs)>,
 <OBJECT 0x122ddba08 (0x12197c080) (3 refs)>,
 <OBJECT 0x117cfc458 WorksController (13 refs)>,
 <OBJECT 0x117cf7318 WorkImageShowComponent (15 refs)>,
 <OBJECT 0x117cf5c98 Work (4 refs)>]

# What is that initial callcache being referenced by the ROOT?
diff.after.at("0x126c9ab68").data
=>
{"address"=>"0x126c9ab68",
 "type"=>"IMEMO",
 "shape_id"=>0,
 "slot_size"=>40,
 "imemo_type"=>"callcache",
 "references"=>["0x126c9acf8"],
 "file"=>"/Users/bensheldon/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/routing/routes_proxy.rb",
 "line"=>48,
 "method"=>"public_send",
 "generation"=>288,
 "memsize"=>40,
 "flags"=>{"wb_protected"=>true, "old"=>true, "uncollectible"=>true, "marked"=>true}}

# And then a method entry
irb(main):015> diff.after.at("0x126c9acf8").data
=>
{"address"=>"0x126c9acf8",
 "type"=>"IMEMO",
 "shape_id"=>0,
 "slot_size"=>40,
 "imemo_type"=>"ment",
 "references"=>["0x12197c080", "0x12197c080", "0x126c9ade8", "0x126c9b4a0"],
 "file"=>
  "/Users/bensheldon/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/routing/routes_proxy.rb",
 "line"=>33,
 "method"=>"method_missing",
 "generation"=>288,
 "memsize"=>48,
 "flags"=>{"wb_protected"=>true, "old"=>true, "uncollectible"=>true, "marked"=>true}}

# Aha, and a singleton for RoutesProxy!
diff.after.at("0x12197c080").data
=>
{"address"=>"0x12197c080",
 "type"=>"CLASS",
 "shape_id"=>14,
 "slot_size"=>160,
 "class"=>"0x12211c308",
 "variation_count"=>0,
 "superclass"=>"0x12211c3a8",
 "real_class_name"=>"ActionDispatch::Routing::RoutesProxy",
 "singleton"=>true,
 "references"=> [...],
 "file"=>
  "/Users/bensheldon/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/actionpack-7.1.2/lib/action_dispatch/routing/routes_proxy.rb",
 "line"=>33,
 "method"=>"method_missing",
 "generation"=>288,
 "memsize"=>656,
 "flags"=>{"wb_protected"=>true, "old"=>true, "uncollectible"=>true, "marked"=>true}}

# I expect the next object to be the RoutesProxy instance
diff.after.at("0x122ddba08").klass.data["real_class_name"]
=> "ActionDispatch::Routing::RoutesProxy"
```

Sheap is pretty great! In the above example, we were able to find a `Work` model instance in the heap, and then using `find_path` identify what was referencing it all the way back to the heap’s root, which is what causes the object to be “retained”; if there was no path to the root, the object would be garbage collected.

(I have the huge benefit of having John as a colleague at GitHub and he helped me out _a lot_ with this. Thank you, John!)

What we’re looking at is something in Rails’ `RoutesProxy` holding onto a reference to that `Work` object, via a callcache, a method entry ([`ment`](https://tenderlovemaking.com/2018/01/23/reducing-memory-usage-in-ruby.html)), a singleton class, a RouteSet, and then a Controller. What the heck?!

### The explanation

Using Rails’ git history, we were able to find that a [change](https://github.com/rails/rails/pull/46974) had been made to the `RoutesProxy` ’s behavior of dynamically creating a new method: a `class_eval` had been changed to an `instance_eval`.

Calling `instance_eval "def method...."` is what introduced a new singleton class, because that new method is only defined on that one object instance. Singleton classes can be cached by the Ruby VM (they’ll be purged when the cache fills up), and that’s what, through that chain of objects, was causing the model instances to stick around longer than expected and bloat up the memory! It’s not that `instance_eval`ing new methods is itself inherently problematic, but when those singleton methods are defined on an object that references an instance of an Action Controller, which has many instance variables that contained big Active Record objects…. that’s a problem.

(Big props, again, to John Hawthorn who connected these dots.)

Having tracked down the problem, we submitted a [patch to Rails](https://github.com/rails/rails/pull/50298) to change the behavior and remove the `instance_eval` -defined methods. It’s been accepted and ~~it should be released in the next Rails patch (probably v7.1.3); the project temporarily [monkey-patched in that change](https://github.com/sciencehistory/scihist_digicoll/pull/2466) too~~ has been released [as part of Rails 7.1.3](https://github.com/rails/rails/blob/36c1591bcb5e0ee3084759c7f42a706fe5bb7ca7/actionpack/lib/action_dispatch/routing/routes_proxy.rb#L30-L47).

_I realize that’s all a big technical mouthful, but the takeaway should be: [Sheap](https://github.com/jhawthorn/sheap) is a really great tool, and exploring your Ruby heap can be very satisfying._

**Update:** Jean Boussier pointed me to the fix in Ruby 3.3 for [call Cache for singleton methods can lead to "memory leaks"](https://bugs.ruby-lang.org/issues/19436) 🎉 And suggested looking at [`harb`](https://github.com/csfrancis/harb) too as a Sheap-like.
