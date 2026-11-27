---
date: '2020-10-05 11:24 -0700'
published: true
title: 'GoodJob v1.3: Web dashboard and full documentation'
tags: 
  - GoodJob
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "81b0f3917a62b846"
  vector: "9Pv/AAAA9gDzCP0IBAICBBD9APr4/wL+Avv39v/49PwAA/sFDAH3BP//9wD+9P/yAAPz9gf/AgX/9///CAMB+gz7+Qj+A/z/+vz9A/4B/fMDA/8O+f8A/gP+BwEGAfz9AQT7DAEBCPb8Bv4M+gEGBfYC/Ab5+wEHDhMGBAT+/QAICAEHBwb8APf/BhD9B/r0+gcCAfv89wYIBwYH/gT8BAT9APv19/729gT4+gEBBQIP/vz6BQz3+QoDBgMBA/v59gEBCgb++gsC/gH7+gL9AgX9/wAG/QsF/wgBCfwHBgAB/QYNBgECBvv+Avn7/wb9+fP4AAAH+QMICfn+9wH++vj/AwD+/wH+DAMJ/PkK/QP2/f8AAwEA+v/8+gb6BwUFAO4ABPoD/P0C+ggFBPn2AfoCCgELCAEJAwj1//QQBQD9Cfr8//f4D/sMCffxAAT9AAX+9AICCv8BAvUE/PUFBAD8CPzxAAUFAg36Av8D9/v69fL2BAMCCwf9BgMG9vcG"
---
[GoodJob](https://github.com/bensheldon/good_job) version 1.3 is released. GoodJob is a multithreaded, Postgres-based, ActiveJob backend for Ruby on Rails. If you're new to GoodJob, read the [introductory blog post](https://island94.org/2020/07/introducing-goodjob-1-0).

GoodJob's v1.3 release adds a mountable Web Dashboard and improved README documentation and complete code-level YARD documentation.

Version 1.3's release comes five weeks after v1.2 and three months after GoodJob's initial v1.0 release.

## Shoutouts 🙌

GoodJob has accepted contributions from 9 people total, and currently has 559 stars on Github. The project just passed 150 combined Issues and Pull Requests.

I'm grateful for everyone who has reached out to me on [Ruby on Rails Link Slack (@bensheldon)](https://www.rubyonrails.link/) and [Twitter (@bensheldon)](https://web.archive.org/web/20200723181116/https://twitter.com/bensheldon)

🙏

## Mountable web dashboard

GoodJob v1.3 adds a web dashboard for exploring and visualizing job status and queue health.

<img src="/uploads/2020-10/good_job-dashboard-mvp.png" alt="GoodJob Dashboard MVP">

The web dashboard is implemented as an optional Rails::Engine and includes charts and lists of pending jobs.

I expect the web dashboard to be a hot area of ongoing improvement. This initial release contains a minimum functional interface, a chart, and some necessities like keyset pagination. The dashboard is familiar to develop (Rails Controllers, ERB Views and ActiveRecord), and I've adopted Bootstrap CSS and Chartist to ease and speed development.

## Improved documentation

GoodJob's README has been edited and rewritten for clarity and comprehensiveness, and GoodJob's implementation code is now thoroughly documented with YARD.

Good documentation is vital for open source projects like GoodJob. I worked with [Rob Brackett](https://robbrackett.com/), who consults on complex software and open source challenges.

## Upcoming

In the next release, v1.4, I plan to continue adding views and charts to the web dashboard and improving thread management.

## Contribute

Code, documentation, and curiosity-based contributions are welcome! Check out the [GoodJob Backlog](https://github.com/bensheldon/good_job/projects/1), comment on or open a Github Issue, or make a Pull Request.

I also have a [GitHub Sponsors Profile](https://github.com/sponsors/bensheldon) if you're able to support GoodJob and me monetarily. It helps me stay in touch and send you project updates too.
