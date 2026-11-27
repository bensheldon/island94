---
title: "Rails Active Record: Will it bind?"
date: 2024-03-31 10:15 PDT
published: true
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "5d17742d5213855e"
  vector: "9QX+EvgCAv/8Av4HB/0FBwv59/4GBwMH+PID/gME8/z3CgEABvv++wz//wL9//8C9/34AQL7AAb+9f0D+f78Avb0/AQIAvj/9gIEAwb39/T38vgDBvkG/A/5AgX2AwQGCQMCBAkJAP33/gH8+P8FAg/5Awr/BPv9Bgr+AQD2AwAN/v79/A8GBAEM+gD/AP8IAQIFEQL47QcC/PwG+/73BvQAAQb8BP/7AAQBAgL5+gT/AQgACAL6/QsMBAv89vr9AgwFAQoBBgf8/v/5BgH+DQgB9w38/gMDAP8CAgcBBQAM/QAHBPUK+QD2BPgP+gj+/Pr9CwEI8wUHAvkD7gH49AEC9v7/+wQBCwT+BP0I/v74CPv89gIH9vT2AP79DAQC+fsLAAb4/gEIBwIF/f/5DPb9BwX3FAAH/v8E+fwDAgAACwL8AfMFAf4EBfr4/QUCAfT2+AAG/QEFAvcEDQEE9AD8AvoA/AAEAv75/v32/vkC/vr+A/z9+wT+/PsB9fcG"
---

Active Record, Ruby on Rail’s ORM, has support for Prepared Statements that work _if you structure your query for it_. Because of my work on GoodJob, which can make a lot of nearly identical database queries every second to pop its job queue, I’ve invested a lot of time trying to make those queries as efficient as possible.

Prepared Statements are a database feature that allow the database to reuse query parsing and planning when queries are structurally the same. Prepared statements, at least in Postgres, are linked to the database connection/session and stored in memory in the database. This implies some things:

- There can be a **performance benefit** to making queries “preparable” for Prepared Statements which Active Record will decide for you based on how a query is structured.
- There can be a **performance harm** (or at least non-useful database processing and [memory growth](https://github.com/rails/rails/issues/14645)) if your application produces a lot of preparable queries that are never reused again.

By default, Rails will have the database store 1,000 queries (`statement_limit: 1000`). Many huge Rails monoliths (like GitHub, where I work) disable prepared statements (`prepared_statements: false`) because there is too much query heterogeneity to get a performance benefit and the database spends extra and unnecessary cycles storing and evicting unused prepared statements. But that’s maybe not your application!

Structurally similar queries can still have variable values inside of them: these are called **bind parameters**. For example, in GoodJob, I want pop jobs that are scheduled to run right now. In SQL that might look like:

```sql
SELECT * FROM good_jobs WHERE scheduled_at < '2024-03-31 16:44:11.047499`
```

That query has the downside of the timestamp changing multiple times a second as new queries are emitted. What I want to do is extract out the timestamp into a bind parameter (a `?` or `$1` depending on the database adapter) instead of embedded in the query:

```sql
SELECT * FROM good_jobs WHERE scheduled_at < ?
```

That’s the good stuff! That’s ideal and preparable 👍

But that’s raw SQL, now how to do that in Active Record? In the following exploration, I’m using the private `to_sql_and_binds` method in Active Record; I’m also using the private Arel API. This is all private and subject to change, so be sure to write some tests around this behavior if you do choose to use it. Here’s some [quick experiments](https://github.com/bensheldon/rails_tricks/blob/6c686c987ee9996bbad8a6ade1f92184c5a9ebf6/bind_params.rb) I’ve done:

```ruby
job = Job.create(scheduled_at: 10.minutes.ago)

# Experiment 1: string with ?
relation = Job.where("scheduled_at < ?", Time.current)
# =>  Job Load (0.1ms)  SELECT "good_jobs".* FROM "good_jobs" WHERE (scheduled_at < '2024-03-31 16:34:11.064614')
expect(relation.to_a).to eq([job])
_query, binds, prepared = Job.connection.send(:to_sql_and_binds, relation.arel)
expect(binds.size).to eq 0 # <-- Not a bind parameter
expect(prepared).to eq false # <-- Not preparable

# Experiment 2: Arel query with value
relation = Job(Job.arel_table['scheduled_at'].lt(Time.current))
# =>  Job Load (0.1ms)  SELECT "good_jobs".* FROM "good_jobs" WHERE scheduled_at < '2024-03-31 16:34:11.064614'
expect(relation.to_a).to eq([job])
_query, binds, prepared = Job.connection.send(:to_sql_and_binds, relation.arel)
expect(binds.size).to eq 0 # <-- Not a bind parameter
expect(prepared).to eq true # <-- Yikes 🥵

# Experiment 3: Arel query with QueryAttribute
relation = Job.where(Job.arel_table['scheduled_at'].lt(ActiveRecord::Relation::QueryAttribute.new('scheduled_at', Time.current, ActiveRecord::Type::DateTime.new)))
# =>  Job Load (0.1ms)  SELECT "good_jobs".* FROM "good_jobs" WHERE scheduled_at < $1  [["scheduled_at", "2024-03-31 16:34:11.064614"]]
expect(relation.to_a).to eq([job])
_query, binds, prepared = Job.connection.send(:to_sql_and_binds, relation.arel)
expect(binds.size).to eq 1 # <-- Looking good! 🙌
expect(prepared).to eq true # <-- Yes! 👏
```

That very last option is the good one because it has the bind parameter (`$1`) and then the Active Record logger will show the values in the nested array next to the query. The successful combination uses:

- Arel comparable syntax
- Wrapping the value in an `ActiveRecord::Relation::QueryAttribute`

Note that many Active Record queries will automatically do this for you, but _not all of them_. In this particular case, it’s because I use the “less than” operator, whereas equality does make it preparable. **You’ll have to inspect each query yourself.** For example, it’s also necessary with `Arel#matches`/`ILIKE`. It’s also possible to temporarily disable prepared statements within a block in the [undocumented](https://github.com/rails/rails/blob/6f0d1ad14b92b9f5906e44740fce8b4f1c7075dc/activerecord/lib/active_record/connection_adapters/abstract_adapter.rb#L368-L373) (!) `Model.connection.unprepared_statement { your_query }`.

**The above code is true as of Rails 7.1. [Jean Boussier has improved Active Record](https://github.com/rails/rails/pull/51139) in newer (currently unreleased) Rails to also properly bind `Job.where("scheduled_at < ?", Time.current)` query syntax too 🙇**

Update: I realized I didn't try beginless/endless range values. Good news: they create bind parameters 🎉

```ruby
# Experiment 4: beginless range
relation = Job.where(scheduled_at: ...Time.current)
# =>  Job Load (0.1ms)  SELECT "good_jobs".* FROM "good_jobs" WHERE scheduled_at < $1  [["scheduled_at", "2024-03-31 16:34:11.064614"]]
expect(relation.to_a).to eq([job])
_query, binds, prepared = Job.connection.send(:to_sql_and_binds, relation.arel)
expect(binds.size).to eq 1 # <-- Looking good! 🙌
expect(prepared).to eq true # <-- Yes! 👏
```
