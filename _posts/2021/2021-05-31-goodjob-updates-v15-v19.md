---
title: "GoodJob Updates v1.5 - v1.9: Dashboard, daemonize, async_server, and graceful shutdowns"
date: 2021-05-31 20:14 PDT
published: true
tags: 
  - GoodJob
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "e1b4a3f07344c9e1"
  vector: "7fkBA/8E+vryCAAH/f8C/REG9/T4+gX/+/H89vv58/sAAfwMAwH4AgL+9v748gX0/QL/9QQIBgQE+/z/CAX4+AP7+Qj9APz8+f/6/wH9//T//wEG/gICBwsCBwkH/v39BQv5CQEACvwAB/wJAf3/Bv4BAAf8AwIBDg0F+wX//AAGAfsHBAT5//b+BAv5C/ry/AQHBv0A8QUG/wUFAgcAA/8A/f3w+vzw/gf0AQb6CQEQAgb7AQb3AQoG/wMC//z4APsGBAQA+wr/BP77/AT3AwYB9vsHAwcE/QECBgMK/wAE9AAOCAIC/vn+AvkB+gP3/fn9AQEG+QcGBfEI9gAA+f0F///6AQD+FQIGAfYK8gDy/wD7/gMFAAD6/g35BBEK/fYCA/0CBAL6Af/8A/f0BfgFBAYCCAEMCgX+APkLAwABAwL6/vP5Cf8HCfj4Agn7BQUA9wIICQH+B/4D+vsFBgD3AgTz9gQHCAn/AAL//Pb79fb+AgMAAgL6CQMG8/wC"
---

This is a quick roundup of what's new with GoodJob since the last update published for [GoodJob v1.4](https://island94.org/2021/01/goodjob-1-4-jruby-compatibility-and-more).

GoodJob ([github](https://github.com/bensheldon/good_job)) is a multithreaded, Postgres-based, ActiveJob backend for Ruby on Rails. If you’re new to GoodJob, read the [introductory blog post](https://island94.org/2020/07/introducing-goodjob-1-0) .

_For further details on the following updates, check out GoodJob's [Changelog](https://github.com/bensheldon/good_job/blob/main/CHANGELOG.md) or [Readme](https://github.com/bensheldon/good_job/blob/main/README.md)._

### GoodJob v1.5: Web Dashboard and configuration

GoodJob ships with a [web dashboard](https://github.com/bensheldon/good_job#dashboard) to display future, finished and errored jobs for easy inspection. The Dashboard mounts as a self-contained Rails Engine.

GoodJob uses more `Rails.application.config...` for improved autoloading compatibility; deprecation notices have examples for updating configuration.

### GoodJob v1.6: Daemonize

GoodJob can run as a backgrounded daemon for folks who are still managing servers with `--daemonize`.

### GoodJob v1.7: Scheduled job cache

GoodJob caches scheduled jobs (i.e. `ExampleJob.set(wait: 30.minutes).perform_later`) for signifiantly improved latency without relying upon polling.

### GoodJob v1.8: Graceful shutdown

GoodJob added additional shutdown options, including `GOOD_JOB_SHUTDOWN_TIMEOUT` to allow jobs to finish before exiting.

### GoodJob v1.9: async_server mode

GoodJob added an additional `async` execution mode to simplify the default configuration: running jobs as part of the web-process (and _not_ console, Rake commands, etc.)

### Upcoming: cron and concurrency controls

GoodJob will add support for cron-style repeating jobs, and concurrency controls to ensure that only a specified number (1 or more) jobs are enqueued or performed at the same time. I previously was opposed to extending ActiveJob's interface, but [have changed my mind](https://github.com/bensheldon/good_job/issues/255); it's on!

### Contribute

Code, documentation, and curiosity-based contributions are welcome! Check out the [GoodJob Backlog](https://github.com/bensheldon/good_job/projects/1), comment on or open a Github Issue, or make a Pull Request. **Thank you!!!** to everyone who has contributed to GoodJob, including morgoth, tedhexaflow, weh, lauer, reczy, zealot128, gadimbaylisahil, Mr0grog, thilo, arku, sj26, jm96441, thedanbob, and joshmn.

I also have a [GitHub Sponsors Profile](https://github.com/sponsors/bensheldon) if you’re able to support GoodJob and me monetarily. It helps me stay in touch and send you project updates too.
