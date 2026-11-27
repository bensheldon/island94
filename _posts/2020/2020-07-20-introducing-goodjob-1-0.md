---
date: '2020-07-20 14:12 -0700'
published: true
title: >-
  Introducing GoodJob 1.0, a new Postgres-based, multithreaded, ActiveJob
  backend for Ruby on Rails
tags:
  - GoodJob
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "adfa79924cc5abc8"
  vector: "7vr+B/sE+fn6Bf4N/voFABYB+/v8+v7//PP++/v49/0EB/gIBP33/gEB9P/49AX7//r//QIEBAgF+voDAP7+9g33+wH8/v789QH5/QP7/Pv+/v0G+v79/AsBBQoMAwH/Awv7AgkEDfsAAv8E//wFCAUF/gr9/wcEDA0G/wH5/QAABAAC+Ab8/foC/wb8Bgj29wUMDQD99AYG/Qn/AAP8BwIG/gL3/v3z9gn6/gb9AgMABwX+DAn6/AwIBQoC+PkD/AMICAcD/gf+/gH7+wX7BAME+AADAgcE/wkAAwYICgAD8vwOC/4C+/L5/fsCAgn2/vv7BwIG+goJBOgB8gL9/gMF/P/2/gYADv8G//YL9ff2Af4C+f8D9/z6+Ab+BQoJAPULAf3/AgICDP0CA/n1Bu3+BwgBBv0C/gH5+vEGAQAF//3+/vX4CAEJCPn7BAcBBP78+gIK/wP4Bf4BCPoF/v/+BgD0/wUDBwf+AQT+9fv6+vUBAAIFBwb6AgYI8foF"
---
[GoodJob](https://github.com/bensheldon/good_job) is a new Postgres-based, multithreaded, second-generation ActiveJob backend for Ruby on Rails.

**Inspired by Delayed::Job and Que, [GoodJob](https://github.com/bensheldon/good_job) is designed for maximum compatibility with Ruby on Rails, ActiveJob, and Postgres to be simple and performant for most workloads.**
* **Designed for ActiveJob.** Complete support for async, queues, delays, priorities, timeouts, and retries with near-zero configuration.
* **Built for Rails.** Fully adopts Ruby on Rails threading and code execution guidelines with Concurrent::Ruby.
* **Backed by Postgres.** Relies upon Postgres integrity and session-level Advisory Locks to provide run-once safety and stay within the limits of schema.rb.
* **For most workloads.** Targets full-stack teams, economy-minded solo developers, and applications that enqueue less than 1-million jobs/day.

[Visit Github for instructions on adding GoodJob to your Rails application](https://github.com/bensheldon/good_job) , or read on for the story behind GoodJob.

### A “Second-generation” ActiveJob backend

Why “second-generation*”? GoodJob is designed from the beginning to be an ActiveJob-backend in a conventional Ruby on Rails application.

First-generation ActiveJob backends, like Delayed::Job and Que, all predate ActiveJob and support non-Rails applications. First-generation ActiveJob backends are significantly more complex than GoodJob because they separately maintain a lot of functionality that comes with a conventional Rails installation (ActiveRecord, ActiveSupport, Concurrent::Ruby) and re-implement job lifecycle hooks so they can work apart from ActiveJob. I’ve observed that this can make them slow to keep up with major Rails changes. An impetus for GoodJob was reviewing the number of outages, blocked upgrades, and forks of first-generation backends I’ve managed during both major and minor Rails upgrades over the years.

As a second-generation ActiveJob backend, GoodJob can draft off of all the advances and solved problems of ActiveJob and Ruby on Rails. For example `rescue_from`, `retry_on`, `discard_on` are all implemented already by ActiveJob.

GoodJob is significantly thinner than first-generation backends, and over the long run hopefully easier to maintain and keep up with changes to Ruby on Rails. For example, GoodJob is currently ~600 lines of code, whereas Que is ~1,200 lines, and Delayed::Job is ~2,300 lines (2,000 for `delayed_job`, and an additional 300 for `delayed_job_active_record`).

_*“Second generation” was coined for me by Daniel Lopez on [Ruby on Rails Link Slack](https://rubyonrails-link.slack.com/archives/C0GB80GRE/p1594860261410500)._

### Postgres-based

I love Postgres. Postgres offers a lot of features, has safety and integrity guarantees, and simply running fewer services (skipping Redis) means less complexity in development and production.

GoodJob builds atop ActiveRecord. It’s numbingly boring, in a good way.

GoodJob uses session-level Advisory Locks to provide run-once guarantees with relatively little performance implications for most workloads.  

GoodJob’s session-level Advisory Lock implementation is perhaps the only “novel” aspect, that comes from my experience orchestrating complex web-driving of government systems (“the browser is the API”) for [Code for America](https://codeforamerica.org/). GoodJob uses a Common Table Expression (CTE) to find, lock, and return the next workable job in a single query. Session-level Advisory Locks will gracefully relinquish that lock if interrupted, without having to maintain a transaction for the duration of the job.

### Multi-threaded

GoodJob uses [Concurrent::Ruby](https://github.com/ruby-concurrency/concurrent-ruby) to scale and manage jobs across multiple threads. “*Concurrent Ruby makes one of the strongest thread-safety guarantees of any Ruby concurrency library”.* Ruby on Rails has adopted Concurrent Ruby, and GoodJob follows its lead and [thread-execution and safety guidelines](https://guides.rubyonrails.org/threading_and_code_execution.html).

In building GoodJob I leaned heavily on my positive experiences running Que, another multithreaded backend, on Heroku. Threads are great for balancing simplicity, economy, and performance for typical IO-bound workloads like heavy database queries, API requests, Selenium web-driving, or sending emails.

A feature that won’t be in GoodJob 1.0, but I hope to implement soon, is the ability to run the GoodJob scheduler inside the webserver process (“async mode”). This was a feature [withdrawn from Que](https://github.com/que-rb/que/issues/238#issuecomment-480648845) , but I believe can be safely implemented with Concurrent Ruby. An async mode would offer even greater economy, for example, in Heroku’s constrained environment.

### GoodJob is right for me

GoodJob’s design is based directly on my experience in 2-pizza, full-stack teams, and as an economy-minded solo developer. GoodJob already powers [Day of the Shirt](https://dayoftheshirt.com/) and [Brompt](https://brompt.com/) performing tens-of-thousands of real-world jobs a day.

### Is GoodJob right for you?

[Try it out](https://github.com/bensheldon/good_job) and let me know.
