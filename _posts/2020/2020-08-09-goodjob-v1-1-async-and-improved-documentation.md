---
date: '2020-08-09 20:49 -0700'
published: true
title: 'GoodJob v1.1: async and improved documentation'
tags: 
  - GoodJob
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "e71c594f2aa1f60f"
  vector: "7fj+CfwA+vb2Cf0L+/wB/xf8/Pv5+gMA/fL48v33+fgBCP4IAPn5AwgA8QP29wL5AP79/P0FAgUG9/gDBAD7+gv6/wcA/wEC+P75AQD8+/n7/v4DAQD//Qz+BgcGAwYACA76AAUBCvYEBPoC/vwABAQG/goD/AMECwwE/gT5/gAF/QH9/QX++/v9AAP5Avnw/AYKDAAB7QUCAgX/AQf7CPoG/AH1//7z+gb3+P77/QQIAgX8Cwn8/Q0HAwwE/PUC//gECgUD+wkA/AD7/AL4AQIG+v4EBAYEAAUFBQUCBgAD7/wTCAMF+fcB+fv+AA73Afz/BQEF/wcJAPEC9v/+AP8E/Pz7BQL7E/wC/voI8/v1BP7/+wIB+f73AwX/BQf/APUIAAEBAgb/CgAEA/f4CfAGBwsCCAUJAAP9/PYLAAACA/0BAfX4DAQMCPsBBQj+BgH8+AEJAAP7B/8IBfcC/v/3AwH8/AkBAwcBAAYA9Pn4+/X+/wQEBgXzAwQN9foI"
---
[GoodJob](https://github.com/bensheldon/good_job) version 1.1 has been released. GoodJob is a multithreaded, Postgres-based, ActiveJob backend for Ruby on Rails. If you’re new to GoodJob, read the [introductory blog post](https://island94.org/2020/07/introducing-goodjob-1-0).

GoodJob’s v1.1 release contains a new, economical execution mode called "async" to execute jobs within the webserver process with the same reliability as a separate job worker process.

This release also contains more in-depth documentation based on feedback and questions I've received since the v1.0 release.

Version 1.1 comes out 3 weeks after GoodJob v1.0. The initial release of GoodJob was featured on [Ruby Weekly](https://rubyweekly.com/issues/511), [A Fresh Cup](https://web.archive.org/web/20200810221115/https://afreshcup.com/home/2020/07/30/double-shot-2651)

, [Awesome Ruby](https://ruby.libhunt.com/newsletter/219), and was as high as #8 on [Hacker News](https://news.ycombinator.com/item?id=23928891). GoodJob has since received nearly [500 stars on Github](https://github.com/bensheldon/good_job).

## Async mode

In addition to the `$ good_job` executable, GoodJob now can execute jobs inside the webserver process itself. For light workloads and simple applications, combining web and worker into a single process is very economical, especially when running on Heroku's free or hobby plans.

GoodJob's async execution is compatible with Puma, in multithreaded (`RAILS_MAX_THREADS`), multi-process (`WEB_CONCURRENCY`), and memory efficient `preload_app!` configurations. GoodJob is built with Concurrent Ruby which offers excellent thread and process-forking safety guarantees. Read the [GoodJob async documentation](https://github.com/bensheldon/good_job#executing-jobs-async--in-process) for more details.

On a personal level, I’m very excited to have this feature in GoodJob. Async execution was _the_ compelling reason I had previously adopted Que, another Postgres-based backend, in multiple projects and I was heartbroken when [Que dropped support for async execution](https://github.com/que-rb/que/issues/238#issuecomment-480648845).

## Improved documentation

Since GoodJob was released 3 weeks ago, the documentation has been significantly expanded. It contains more code and examples for ensuring reliability and handling job errors. I've had dozens of people ask questions through [Github Issues](https://github.com/bensheldon/good_job/issues) and [Ruby on Rails Link Slack](https://www.rubyonrails.link).

## Upcoming

In the next release, v1.2, I plan to simplify the creation of multiple dedicated threadpools within a single process. The goal is to provide an economical solution to congestion when the execution of a number of slow, low-priority jobs (elephants) are being performed and there are no execution resources available for newly introduced fast, high priority jobs (mice) until the currently executing elephants complete.

A proposed configuration, for example:

`--queues=mice:2,elephants:4`

...would allocate 2 dedicated threads for jobs enqueued on the mice queue, and 4 threads for the elephants queue. Learn more in the [feature's Github Issue](https://github.com/bensheldon/good_job/issues/45).

## Contribute

GoodJob continues to be enjoyable to develop and build upon Rails' ActiveJob and Concurrent Ruby. Contributions are welcomed: check out the [GoodJob Backlog](https://github.com/bensheldon/good_job/projects/1), comment on or open a Github Issue, or make a Pull Request.
