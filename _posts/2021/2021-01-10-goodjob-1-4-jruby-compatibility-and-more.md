---
date: '2021-01-10 20:12 -0800'
published: true
title: 'GoodJob 1.4: JRuby compatibility and more'
tags:
  - GoodJob
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "06e2d16b11ea11e2"
  vector: "8vX+/PwG8fzx//kP//0C/BMF+vX0+wH5APH89Pj6+/v9AfwIBP75AwIF9gT19AP2A/339gkEBAH4/f7/AgQA+gj2+QEB+vv/+AD2BAAECPj5/vwC+v/5AAcGDAIHBPkBAgv9BgMEBwP/A/oJ+vwFAf8CAQMDAf38DQ0F+gMB+AAHAgkD+wP2Bv0A/gz7/vr39/8FDQP/9AwHBAn+/wj3BPsAAPvw//rz+QH1AA4ACQULAQH6CA38AgsMBgYBBAD///wCBAIGAAv9BgL2+wH9AAL/+wAHAQYF/woFDQQMBAAD9gMPAwAE//v7+/sBAAb8+f74Bv8M+wcMAfUI9gEJAPwA/P7+/QYAEQABAfoG8wX+Afj+/AMB+///9A75/woFAu8NBwEDBf4EAQYGAvf0BfMHBAYHBAIDAP3+/PIH/QAJAPv6//jzCP8LCPj7AAf8AgH6+gL/BAT8AvsBAfoIBAP6Av34/wcFBQX4AfoA+Pv5/fYGAAEICAT6B/8F9PsB"
---
[GoodJob](https://github.com/bensheldon/good_job) version 1.4 is released. GoodJob is a multithreaded, Postgres-based, ActiveJob backend for Ruby on Rails. If you’re new to GoodJob, read the [introductory blog post](https://island94.org/2020/07/introducing-goodjob-1-0) .

GoodJob’s v1.4 release adds support for:

- JRuby
- MRI 3.0
- Rails 6.1
- Postgres 12+

And includes additional improvements to the Web Dashboard.

Version 1.4’s release comes three months after v1.3 and five months after GoodJob’s initial v1.0 release.

## JRuby compatibility

GoodJob 1.4 adds compatibility for Ruby on Rails applications running under JRuby. GoodJob's multithreading is built on top of [ConcurrentRuby](https://github.com/ruby-concurrency/concurrent-ruby), which provides consistent behavior and guarantees on all four of the main Ruby interpreters (MRI/CRuby, JRuby, Rubinius, TruffleRuby).

A minor downside of JRuby is that JRuby's database adapter, [`activerecord-jdbc-adapter`](https://github.com/jruby/activerecord-jdbc-adapter), does not support Postgres LISTEN, which means GoodJob must rely on polling for new jobs under JRuby.

## Broader compatibility and improvements

In addition to JRuby, GoodJob 1.4 adds compatibility for MRI 3.0, Rails 6.1, and Postgres 12+.

GoodJob 1.4 also includes improved filtering for the Web Dashboard,.

## What's next

The next version of GoodJob will add support for daemonization.

## Contribute

Code, documentation, and curiosity-based contributions are welcome! Check out the [GoodJob Backlog](https://github.com/bensheldon/good_job/projects/1) , comment on or open a Github Issue, or make a Pull Request.

I also have a [GitHub Sponsors Profile](https://github.com/sponsors/bensheldon) if you’re able to support GoodJob and me monetarily. It helps me stay in touch and send you project updates too.
