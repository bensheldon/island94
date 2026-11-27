---
title: "Solid Queue first impressions: Nice!"
date: 2023-12-19 08:24 PST
published: true
tags: [Rails, GoodJob]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "e00317963c51083c"
  vector: "7/j5BvYC//P8BQAGAf3+/RH6//v5+f3/+fn7//v19AL7B/0IBPz7/Qb68wQB8QH5+/35+wUICgcC+Pz++f8B/QD9/AwABfz/9gH/BQD59fL8/QED/PkE+gn6DQ0F+gMEAwkBBAUEBfz8AP8B+/n+BwP6+g31+QQEAgn6AgMFAgAEAAT/Af8DA/4C+Qb7AP71+QoGBgEA8QcFBQX9Agj+Cv0B/AbxAQHv/Qb0////AwEA/QYACQr9AQkDBw4BAPYBAQb+AQ39AQUD9wX++/v//An/+fME9ggD+wT7AwwGAgAF8/8NBQH++AMC9/oE/QL+APX4CgAE/BIBB/n/9wb59f4F//r+CQIBB/8C//kM9/3w/fgA+wQD/vv5+wz/Aw0ABfoG+P4C/wb4BQMC//P1BfIBBwH7BgoC///7/PkE/gD+AAUFB+j+EQUHDfgB/g8CBvv4/AYLBAL/BQIACgID+gQBBf4B/AIDAgT3AQf88wD8/vv8AAQHAgb+CggJ8/oK"
---

[Solid Queue](https://github.com/basecamp/solid_queue) was [released yesterday](https://dev.37signals.com/introducing-solid-queue/), a new relational-database backend for Active Job.

I'm the author of [GoodJob](https://github.com/bensheldon/good_job) and I've been [following along](https://island94.org/2023/10/reflections-on-good-job-for-solid-queue) and am very interested and excited about Solid Queue. These are some things I noticed when first going through it.

**tl;dr;** It's nice! I learned some things. It makes a few different choices than GoodJob and I'm very curious how they turn out (in a good way!).

I admit, I didn't run Solid Queue in production. I poked through the code, got the development environment set up (spent the majority of my time trying to get `mysql2` to compile, which is no surprise for me; [Trilogy is my day job](https://github.blog/2022-08-25-introducing-trilogy-a-new-database-adapter-for-ruby-on-rails/)), ran the test suite and tried TDDing a new feature for it: `perform_all_later` support. These are just my notes, something to refer back to.

**Lots of database tables:** Solid Queue has many database tables. There is a "hot" table (my terminology) in which job records are queued/dequeued/locked from by all the workers, and then several other tables where job records are staged (e.g. they're scheduled in the future, so don't insert them into the hot table yet) or archived after they complete/error. This seems smart because that hot table and its indexes stays compact and single purpose, which is good for performance. Compare that to GoodJob in which the jobs table has like 8 indexes to cover both queue/dequeue and Dashboard listings and everything else, which _does_ slow down inserts and updates. I've had the impression with GoodJob that orchestrating across multiple tables would be more difficult (everything is tradeoffs!), so I'm very curious to see an alternative implementation in Solid Queue.

_Note: I wasn't successfully able to implement `perform_all_later` in my 1 hour timebox because it was more complicated than an `insert_all` because of the necessity of writing to multiple tables._

_Aside: One of the very first comments I got when I launched GoodJob 3 years ago was like "your design assumptions are less than ideal" and then they never replied to any of my follow-ups. That sucked! This is not that. Nothing in Solid Queue is particularly concerning, just different (sometimes better!). Kudos to Rosa Gutiérrez and the Solid Queue developers; you're doing great work! 💖_

**Again, lots of database tables:** GoodJob is easy mode just targeting Postgres, because there are Advisory Locks and lots of Postgres-only niceties. I do not envy Solid Queue being multi-database, because it has to implement a bunch of stuff with a coarser toolbox. For example, there is a `semaphores` table, which is used for the Concurrency Controls feature (🎉). I think the "SOLID" libraries (also Solid Cache) are interesting because they have to implement behavior in a relational database that come for free in in-memory databases (example: TTL/record expiration/purging).

**Puma Plugin:** TIL. Looks nicer and more explicit than GoodJob trying to transparently detect it's in the webserver to run asynchronously

**Multiprocess.** A nice surprise to me, Solid Queue has a multiprocess supervisor. It does seem like even the Puma plugin forks off another process though; that could have implications for memory constrained environments (e.g. Heroku dynos). I'm nearly 4 years into GoodJob and haven't tackled multiprocess yet, so exciting to see this in Solid Queue's first release.

**Queue priority:** Nice! I have _opinions_ about how people set up their application's queues, along the lines of: many people do it wrong, imo. Solid Queue looks like it provides a lot of good flexibility to let people easily migrate and configure their queues initially (though wrongly, by dependency, imo), but then reorient them more performantly (by latency, again imo). A single thread-pool/worker can pull from multiple queues.

**Care**. I notice lots of little things that are nice in Solid Queue. The code is clean. The indexes are named for their purpose/usage rather than just like `index_table_column_column`. The Puma Plugin is nice. There are things in GoodJob that I dream about what a clean-room, lessons-learned reimplementation would look like, but it's never top of my priorities, and some things are never going back in the stable (table names are basically forever). Reading the Solid Queue code was a vicarious-nice! experience.

**Differences.** Do they even matter? I dunno:

- No Dashboard yet. Waiting on Mission Control. GoodJob definitely got more twisty as I learned all of the things of "you want a button to do what now with those jobs? ...oh, I guess that makes sense. hmm."
- No LISTEN/NOTIFY (yet?). Seems possible, but would be Postgres only so maybe not. That means latency will never be less than the polling frequency, though an example shows `0.1` seconds which seems good to me.
- ~~No cron-like functionality. It took me a minute to [come around to the the necessity of this](https://github.com/bensheldon/good_job/issues/255), maybe Solid Queue will too.~~ 🤦 I missed this on first read through: "Unique jobs and recurring, cron-like tasks are coming very soon." 🙌

**Final thoughts:** Path dependency is hard, so I don't imagine lots of people should swap out their job backend just because there is something new (please, don't let me ever read a "3 job backends in 4 years" blog post). New projects and applications will be more likely making these choices (and they shouldn't be valueless choices, hence my excitement for Solid Queue becoming first party to Rails) and I'm really excited to see how Solid Queue grows up with them, and alongside other options like GoodJob and Sidekiq and Delayed et al.
