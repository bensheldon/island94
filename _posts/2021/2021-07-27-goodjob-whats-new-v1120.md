---
title: "GoodJob, what's new: Cron, concurrency controls, and a dashboard demo (v1.12.0)"
date: 2021-07-27 06:50 PDT
published: true
tags: 
  - GoodJob
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "30a6d14bec747b10"
  vector: "7P34A/sA/vv4A/4HAwEBAQgB+vUB/wQF9+8A/fv+/vr/CAIL/f39AAUA8PX99f/9//8C+f8FBgcF9wb/BQIA+f348gn/BwH+9ff8AP369Pv09wUD/v4D/w/9AgAH/f/+Bgj9CAL6CfoEBP4H+foFCQQCAw3+BgEKEQoC/gP+AgAFBP8BAAT5Avz+Agj9BPH1/wUICAL77AQD/gcB/wQCEAEK/Ab3Avz2AwH4+wX6CQMHAwP+CAT6+ggDCgYD+fcI/fwHBwcF/g399wL4A/7xCwb++fwGAwQDAAEEAQEHBAAG+AINEQAD/fn5+/YD/gL9+/73B/0BAAcKBvQA/AL2+QAHAPb7BAMIFf8D//gH/f/z//r79QUG9wD8/AkBAgwMAfQD//4GAgn////++/D0CvT9Bgj5CvwMAQX8+voJAAADAv8BAvP+AAAGBPv/AgQACwIB+QYGCgP6CPkKA/oE+/v7/AD2+gEEBwn7Av79+fb8+/j/BwX/CQvzAgQE+PwB"
---

This is a quick roundup of what’s new with GoodJob v1.12.0 since the last update published for [GoodJob v1.9](https://island94.org/2021/01/goodjob-1-4-jruby-compatibility-and-more).

GoodJob ( [github](https://github.com/bensheldon/good_job) ) is a multithreaded, Postgres-based, ActiveJob backend for Ruby on Rails. If you’re new to GoodJob, read the [introductory blog post](https://island94.org/2020/07/introducing-goodjob-1-0).

_For further details on the following updates, check out GoodJob's [Changelog](https://github.com/bensheldon/good_job/blob/main/CHANGELOG.md) or [Readme](https://github.com/bensheldon/good_job/blob/main/README.md)._

### Cron-like replacement for repeating/recurring jobs

GoodJob now ships with a [cron-like replacement for repeating/recurring jobs](https://github.com/bensheldon/good_job#cron-style-repeatingrecurring-jobs). The cron-like process runs either via the CLI, or `async` within the web server process. Repeating jobs can be scheduled to the second, powered by the [Fugit](https://github.com/floraison/fugit) gem. Here’s what the configuration looks like:

```ruby
# config/environments/application.rb or a specific environment e.g. production.rb

# Enable cron in this process; e.g. only run on the first Heroku worker process
config.good_job.enable_cron = ENV['DYNO'] == 'worker.1' # or `true` or via $GOOD_JOB_ENABLE_CRON

# Configure cron with a hash that has a unique key for each recurring job
config.good_job.cron = {
  # Every 15 minutes, enqueue `ExampleJob.set(priority: -10).perform_later(52, name: "Alice")`
  frequent_task: { # each recurring job must have a unique key
    cron: "*/15 * * * *", # cron-style scheduling format by fugit gem
    class: "ExampleJob", # reference the Job class with a string
    args: [42, { name: "Alice" }], # arguments to pass; can also be a proc e.g. `-> { { when: Time.now } }`
    set: { priority: -10 }, # additional ActiveJob properties; can also be a lambda/proc e.g. `-> { { priority: [1,2].sample } }`
    description: "Something helpful", # optional description that appears in Dashboard (coming soon!)
  },
  another_task: {
    cron: "0 0,12 * * *",
    class: "AnotherJob",
  },
  # etc.
}
```

### Concurrency controls

GoodJob now offers an [ActiveJob extension](https://github.com/bensheldon/good_job#activejob-concurrency) to provide customizable limits on the number of jobs enqueued or executed concurrently. Rails might upstream it too. Here's how to configure it:

```ruby
# app/jobs/my_job.rb
class MyJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  good_job_control_concurrency_with(
    # Maximum number of jobs with the concurrency key to be concurrently enqueued
    enqueue_limit: 2,

    # Maximum number of jobs with the concurrency key to be concurrently performed
    perform_limit: 1,

    # A unique key to be globally locked against.
    # Can be String or Lambda/Proc that is invoked in the context of the job.
    # Note: Arguments passed to #perform_later must be accessed through `arguments` method.
    key: -> { "Unique-#{arguments.first}" } #  MyJob.perform_later("Alice") => "Unique-Alice"
  )

  def perform(first_name)
    # do work
  end
end
```

### Dashboard Demo

Don't take my word for what a good job it is. Check out the new GoodJob Dashboard demo running on Heroku entirely within a single free dyno: https://goodjob-demo.herokuapp.com/

### More news:

- Wojciech Wnętrzak aka [@morgoth](https://github.com/morgoth) became a GoodJob maintainer.
- Wrote up details of the [evolving development philosophy](https://github.com/bensheldon/good_job/issues/255) behind GoodJob.
- The Dashboard now allows removing jobs, with more actions coming soon.

### Contribute

Code, documentation, and curiosity-based contributions are welcome! Check out the [GoodJob Backlog](https://github.com/bensheldon/good_job/projects/1) , comment on or open a Github Issue, or make a Pull Request.

I also have a [GitHub Sponsors Profile](https://github.com/sponsors/bensheldon) if you’re able to support GoodJob and me monetarily. It helps me stay in touch and send you project updates too.
