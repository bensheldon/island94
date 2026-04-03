---
title: "Introducing GoodJob v4"
date: 2024-07-06 21:44 PDT
published: true
tags: [GoodJob, Rails]
---

GoodJob version 4.0 has been released! 🎉 GoodJob v4 has breaking changes that should be addressed through a transitionary v3.99 release, but if you've kept up with v3.x releases and migrations, you're likely ready to upgrade 🚀 

The [README has an upgrade guide](https://github.com/bensheldon/good_job?tab=readme-ov-file#upgrading-v3-to-v4). If you'd like to leave feedback about this release, please comment on the [GitHub Discussions post 📣](https://github.com/bensheldon/good_job/discussions/1396)

If you're not familiar with GoodJob, you can read the [introductory blog post](https://island94.org/2020/07/introducing-goodjob-1-0) from four years ago. We've come pretty far.

### Breaking changes to job schema

GoodJob v4 changes how job and job execution records are stored in the database; moving from job and executions being commingled in the `good_jobs` table to Jobs (still in `good_jobs`) having many discrete Execution records in the `good_job_executions` table. 

To safely upgrade, all unfinished jobs must use the new schema relationship, tracked in the `good_jobs.is_discrete` column. This change was transparently introduced in GoodJob [v3.15.4 \(April 2023\)](https://github.com/bensheldon/good_job/releases/tag/v3.15.4), so your application is likely ready-to-upgrade already if you have kept up with GoodJob updates and migrations. You can check by running `v3.99`’s `GoodJob.v4_ready?` in production or run the following SQL query on the production database and check it returns zero: `SELECT COUNT(*) FROM "good_jobs" WHERE finished_at IS NULL AND is_discrete IS NOT TRUE`. If not all unfinished jobs are stored in the new format, either wait to upgrade until those jobs finish or discard them. If you upgrade prematurely to v4 without allowing those jobs to finish, they may never be performed.

### Other notable changes

GoodJob v4:

* Only supports Rails 6.1+, CRuby 3.0+ and JRuby 9.4+, Postgres 12+. Rails 6.0 is no longer supported. CRuby 2.6 and 2.7 are no longer supported. JRuby 9.3 is no longer supported.
* Changes job priority to give smaller numbers higher priority (default: 0), in accordance with Active Job's definition of priority.
* Enqueues and executes jobs via the `GoodJob::Job` model instead of `GoodJob::Execution`
* Changes the behavior of `config.good_job.cleanup_interval_jobs`, `GOOD_JOB_CLEANUP_INTERVAL_JOBS`, `config.good_job.cleanup_interval_seconds`, or `GOOD_JOB_CLEANUP_INTERVAL_SECONDS` set to `nil` or `””` to no longer disable count- or time-based cleanups. Instead, now set to `false` to disable, or `-1` to run a cleanup after every job execution.

### New Features

GoodJob v4 does not introduce any new features on its own. In the 110 releases since GoodJob v3.0 was released (June, 2022), these new features and improvements have been introduced:

* [Batches](https://github.com/bensheldon/good_job#batches)
* Bulk enqueueing including support for Active Job’s `perform_all_later`.
* [Labelled jobs](https://github.com/bensheldon/good_job?tab=readme-ov-file#labelled-jobs)
* Throttling added to [Concurrency Controls](https://github.com/bensheldon/good_job?tab=readme-ov-file#concurrency-controls)
* Improvements to the [Web Dashboard](https://goodjob-demo.herokuapp.com/good_job/jobs), including Dark Mode, performance dashboard, and improved UI,  and customizable templates. 
* Storage of error backtraces. Improved handling of job error conditions, including signal interruptions. Added `GoodJob.current_thread_running?` and `GoodJob.current_thread_shutting_down?` to support job iteration.
* [Ordered Queues](https://github.com/bensheldon/good_job/pull/665), [`queue_select_limit`](https://github.com/bensheldon/good_job/pull/727) and further options for configuring queue order and performance.
* Improvements to Cron / Repeating Jobs.
* Operational improvements including `systemd` integration, improved health checks.

**A huge thank you to 88 (!) GoodJob v3.x contributors 🙇🏻** @afn, @ain2108, @aisayo, @Ajmal, @aki77, @alec-c4, @AndersGM, @andyatkinson, @andynu, @arnaudlevy, @baka-san, @benoittgt, @bforma, @BilalBudhani, @binarygit, @bkeepers, @blafri, @blumhardts, @ckdake, @cmcinnes-mdsol, @coreyaus, @DanielHeath, @defkode, @dixpac, @Earlopain, @eric-christian, @erick-tmr, @esasse, @francois-ferrandis, @frans-k, @gap777, @grncdr, @hahwul, @hidenba, @hss-mateus, @Intrepidd, @isaac, @jgrau, @jklina, @jmarsh24, @jpcamara, @jrochkind, @julienanne, @julik, @LucasKendi, @luizkowalski, @maestromac, @marckohlbrugge, @maxim, @mec, @metalelf0, @michaelglass, @mitchellhenke, @mkrfowler, @morgoth, @Mr0grog, @mthadley, @namiwang, @nickcampbell18, @padde, @patriciomacadden, @paul, @Pauloparakleto, @pgvsalamander, @remy727, @rrunyon, @saksham-jain, @sam1el, @sasha-id, @SebouChu, @segiddins, @SemihCag, @shouichi, @simi, @sparshalc, @stas, @steveroot, @TAGraves, @tagrudev, @thepry, @ur5us, @WailanTirajoh, @yenshirak, @ylansegal, @yshmarov, @zarqman 
