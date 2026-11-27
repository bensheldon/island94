---
title: "On the importance of Rails code reloading and autoloading"
date: 2024-07-07 07:44 PDT
published: true
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "b68df787f4350188"
  vector: "9/v5Bgf7/Qf5B/4O/QL8Awj4+QX8/P8LAfX7+wH3AgL//wAFBPv5/wX+/Af/AAT/APkDAQb0/QAI/gMLAAr9+wACAf4HAwAD9fwD+gD9+PL4+v8DAgIF+QwCBP0GCPwCCwT2Bv4FCQgA+gYO+PwHAQL/CgL9AgIICwcAAAUA/QABAfYR8/v+AgUDBQj+BQH49/4IBwD98f8FCQYI/QEIAQIEAfkGAPj6Awf6+gT7/wz59wcJCw/y/ff2DP8K+voIBP0H/wcF+QICAAjzAfzvB/4A+gAC+Qr4+wUG/gQBBQAP9/4GCvkB/vvy+/j/AgL8+vwGB/UN/v8C/O8I+foGCQD67Q37Bgb7Evz5AQEI+wH5BAX7/vsN/gQA/QgBBAHz+PkBAAUE+QIBAvsD/fv4+PX7/AjwC/sJ//8B/v8I+QAHDQL/BgUJDP0ABAD7Av0C/gP1+vwE/QD6+wT9B/kGBwL//Af+/gn+AQUC/PL47/wB+vgD+QUIBwT5AQQD9/kB"
---

I've elevated to "strongly held belief" that [code reloading and autoloading is _the_ most important design constraint](https://island94.org/2024/04/a-ruby-meetup-and-3-podcasts) when designing or architecting for Ruby on Rails.

- Code reloading is what powers the "make a code change, refresh the browser, see the result" development loop.
- Code autoloading is what allows Rails to boot in milliseconds (if you've designed for it!) to run generators and application scripts and a single targeted test for tight test-driven-development loops.

When [autoloading and reloading](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html) just works, it probably isn't something you think about. When code autoloading and reloading doesn't work or works poorly, as it has on numerous apps across my career and consulting, it can be maddening:

- Spending hours "debugging" some code only to realize that your changes were never being run at all.
- Waiting tens of excruciatingly boring seconds to run a simple test or watching the browser churn away while it slowly waits for a response from the development server.
- Feeling like you can write the code yourself each time faster than running a scaffold/template generator, repetitively over and over again.

Code reloading and autoloading not working correctly is a huge pain. It's not great, at all!

The history of code reloading and autoloading came up recently in the [Rails Performance Slack](https://www.railsspeed.com). A developer working on an old Rails application asked what Spork was (a forking preloader), and whether it was necessary (not necessarily). As a Rails Developer who is increasingly aware of my ~~age~~ experience (I started working with Rails in 2012, long after it first launched in 2004, but it's still been a minute), I realized I had something to share.

Over history, various strategies have been taken to make the development loop faster because that's so important. Those strategies usually boil down to:

- Separating the (static) framework code from the (changing, developed) application code and only loading, just in time, what's needed for the part of the application that's currently running.
- Loading/booting the framework code that is unlikely to change, and then only (re-)load the application code when invoking a command or running a test.

There have been various approaches to doing this:

- Forking Preloaders (Spork, though Spring is the more contemporary version): load up the framework code in a process once, then fork into a subprocess when you invoke a command and reload just the application code. Sometimes, things can get out of sync (some application code or state pollutes the primary process), and things get weird/confusing. This is why you’ll hear of people hating on Spring or complaining, “I wasted all day on a development bug, and it turns out I just needed to restart Spring” (the analogous “it was DNS all along” of the Rails world).
- Bootsnap, though operating on a cache strategy rather than a process-forker, serves a similar purpose of trying to speed up an application's code loading time. The adoption of Bootsnap, and much, much faster CPUs in general, has largely replaced the usage of Spring in applications (though it's still okay!).
- Zeitwerk autoloader also plays a role in this history because it, too, is trying to “solve” the necessity of separating the framework code (which changes infrequently) from the application code during development (which is actively being changed) to produce faster development feedback cycles. Zeitwerk replaced the previous autoloader built into Rails, whose lineage seems to date all the way back to [Rails 2.0 circa 2005](https://github.com/bensheldon/rails/commit/ee014ef95ae9746b4228f3bc7c85ac0df28ba1df). Tell me the history / raison d'être of the original autoloader if you know it!

Look, a lot of labor has gone into this stuff. It's important! And it's easy to get wrong and produce a slow and disordered application where development is a pain. It happens! A lot!

I wish I could easily leave this post with some kind of _nugget_ of something actionable to do, but it's really more like: **please take care**. Some rules of thumb:

- Don't reference, don't access, don't use or touch any constants in `app/`, or allow them to be referenced (looking at you, custom Rack Middleware) unless you're doing so from another constant in `app/` (or somewhere that you _know_ is [autoloaded](https://island94.org/2023/05/whatever-you-do-don-t-autoload-rails-lib)).
- Take care with `config/initializers/` and ensure you're making the most of `ActiveSupport.on_load` hooks. Rails may even be missing [some load hooks](https://guides.rubyonrails.org/engines.html#available-load-hooks), so make an upstream PR if you need to configure an autoloaded object and you can't. It's super common to run into trouble; in writing this blog post alone, I discovered a [problem with a gem I use](https://github.com/textacular/textacular/pull/159).
- If you're writing library code, become familiar with the configuration-class-initializer-attribute-pattern dance (my name for it), which is how you'll get something like `config.action_view.something = :the_thing` lifted and constantized into `ActionView::Base.something #=> TheThing`

You might find luck with this [bin/autoload-check script](https://gist.github.com/bensheldon/ba6532c4216c11dd9ba03487c5a06ee4), that I adapted from something [John Hawthorn](https://www.johnhawthorn.com/) originally wrote, giving output like:

```text
❌ Autoloaded constants were referenced during during boot.
These files/constants were autoloaded during the boot process,
which will result in inconsistent behavior and will slow down and
may break development mode. Remove references to these constants
from code loaded at boot.

🚨 ActionView::Base (action_view) referenced by config/initializers/field_error.rb:3:in `<main>'
🚨 ActiveJob::Base (active_job)   referenced by config/initializers/good_job.rb:7:in `block in <main>'
🚨 ActiveRecord::Base (active_record)
                                         /Users/bensheldon/.rbenv/versions/3.3.3/lib/ruby/gems/3.3.0/gems/activerecord-7.1.3.4/lib/active_record/base.rb:338:in `<module:ActiveRecord>'
                                         /Users/bensheldon/.rbenv/versions/3.3.3/lib/ruby/gems/3.3.0/gems/activerecord-7.1.3.4/lib/active_record/base.rb:15:in `<main>'
                                         .....
```
