---
title: "The Rails Executor: increasingly everywhere"
date: 2023-11-29 21:37 PST
published: true
tags: [Rails, Ruby]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "5e510d370420eeaa"
  vector: "9/z7Dv/6/PsBB/8OAPz+/Q8B9gL+/QMM9/T88/b8/vf5BQgIBP/2/wj++AP+///8+PsFBgL8AwAO+/YNAQP++QH9AQQHAwIB9Pv8CAL48vfz9v//CgEJ+hIBBQICBQEFAAMAAQb6Cv/+BAAB+/YJBA0FAwUFAAQIBxAD/wj+AAAE+/0F+Qj+AQgFBAH+/AEA+QIPDwP18gEBAP4D9gT/BfoD/QIABvr89QH1AP/4+w0DAQn+DgT8AQT+CQQF/PQBAv0JBQMC9ggAAQP0AP/3BQr89v78AQH++QMMAQgCBgAH8QMNDvgB/vb09/cCBgP2+/wGBvsEAf8B/ur89/sAAQIE9wT2AQUEDQUAAf4G+vv3Cfz8/AYG/Pr9+QoB/gMF+PgK/gcCAwD6CgME+PX2CfL8/AMBCPoGBAH8+f0B+QAHB//+BPsFCPkGCwP/AwT5Bfz8/P4H/Qj3A/4CBfcJ+wgA+Qr4AggF/QICAgL89v33+PQB+AgDAQj5+wAB+Pn+"
---

*The Rails Executor rules everything around ~~you~~ your code.*

If you write multithreaded-Rails code—like me, author of [GoodJob](https://github.com/bensheldon/good_job)—you're probably familiar with the Rails Executor which is described in the [Rails Multithreading Guide](https://guides.rubyonrails.org/v7.1/threading_and_code_execution.html).

If you're new to the Rails Executor: it sets up and tears down a lot of Rails' framework magic. Code wrapped with a Rails Executor or its sibling, the Reloader, pick up a lot of powerful behavior:

- Constant autoloading and reloading
- Database connection/connection-pool management and query retries
- Query Cache
- Query Logging
- CurrentAttributes
- Error reporting

You usually won't think about it. The Rails framework already wraps every Controller Action and Active Job with an Executor. Recently, as of Rails v7.1, it's showing up everywhere within the Rails codebase:

- [Rails runner scripts are now wrapped with an Executor](https://github.com/rails/rails/pull/44999)
- [Minitest test cases are now wrapped with an Executor](https://github.com/rails/rails/pull/43550) (I'm working on getting [parity in rspec-rails](https://github.com/rspec/rspec-rails/issues/2713)). It has a nice little explanation why "This helps to better simulate request or job local state being reset around tests and prevent state to leak from one test to another."

The effect of these small changes could be surprising:

- I came to write this blog post because I saw a Rails Discussion asking how ["Rails 7.1 uses query cache for runner scripts"](https://discuss.rubyonrails.org/t/rails-7-1-uses-query-cache-for-runner-scripts/84275) and aha, I knew the answer: the Executor.
- I recently [fixed a bunch of flaky GoodJob unit tests](https://github.com/bensheldon/good_job/pull/1124) by wrapping each RSpec example in a Rails Executor. This is a problem specific to GoodJob, which uses connection-based Advisory Locks, but I discovered that if an Executor context was passed through (for example, executing an Active Job inline), the current database connection would be returned to the pool, sometimes breaking the Advisory Locks when a different connection was checked back out to continue the test. This was only a fluke of the tests, but was a longtime annoyance. I've previously had to [work around a similar reset of CurrentAttributes](https://github.com/bensheldon/good_job/blob/c6d3aa4906783498ed6296060666d350ac2e288c/lib/good_job/current_thread.rb#L6-L7) that occurs too.
- At my day job, GitHub, we've also been double-checking that all of our Rails-invoking scripts and daemons are wrapped with Rails Executors. Doing so has fixed flukey constant lookups, reduced our database connection error rate and increased successful query retries, and necessitated updating a bunch of tests that counted queries that now hit the query cache.

The Rails Executor is great! Your code is probably already wrapped by the Rails framework, but anytime you start writing scripts or daemons that `require_relative "./config/environment.rb"` you should double-check, and _definitely_ if you're using `Thread.new`, `Concurrent::Future` or anything that runs in a background thread.

I used the following code in GoodJob to debug that database connection checkout occurs in a Rails Executor, maybe you could adopt something similar too:

```rb
# config/initializers/debug_executors.rb

ActiveSupport.on_load :active_record do
  ActiveRecord::ConnectionAdapters::AbstractAdapter.set_callback :checkout, :before, (lambda do |conn|
    unless ActiveSupport::Executor.active?
      $stdout.puts "WARNING: Connection pool checkout occurred outside of a Rails Executor"
    end
  end)
end

```

One last thing about Executors, you want to make sure that you’re [wrapping individual units of work](https://guides.rubyonrails.org/v7.1/threading_and_code_execution.html#wrapping-application-code), so the execution context has a chance to reset itself (check-in database connections, unload and reload code, etc.):

```rb
# scripts/do_all_the_things.rb
# ...

# bad
Rails.application.executor.wrap do
  loop { MyModel.do_something }
end

# good
loop do
  Rails.application.executor.wrap { MyModel.do_something }
end
```

**Update:** I offered a [Rails PR to make the script runner's Executor conditional](https://github.com/rails/rails/pull/50223) because the introduction of an Executor around `bin/rails runner script.rb` could introduce problems if the script is long-running/looping/daemon-like; developers would still need to use an Executor, but to wrap individual units of work in their longrunning script.
