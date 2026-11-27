---
title: "Fake the algorithm til you make it"
date: 2023-08-30 15:50 PDT
published: true
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "c926c1422bfc3da3"
  vector: "+P8AAwT/Cgf4/AD9Ef0CAw34++32+wcB/vsB/f8ABAoEBfX++vj/Afz5/QX/Af0M/gbz+QH9AQL9/PsAAPD9Agf9+wwH/AsD8xQCAQH4+QDv/QAEAvYG/AMA+wkD+gUMAfkAC/kE/foE//8HB//4BgABBPoFBAEGBBEH+v8J/QAFBQgE/P78AvwFABMACBD+AAMC+Qb5/f39BP8EDQH/Bvr5AwL6+QUJAQX//vcNAv76AgL6Bw74+AH2Bf8F+P4F+f4D+Q0CBQ/6+wD3BQb5/AYA9gH1AgP79AT0AAYGAQD3+w3/FfH/8gEA9/gN+gcBCf38AP4I8AAEBgD5+gH++/34+wT6Av8BBAT7APgF+/j0AwEC/vf++v8DAgf7CQEH+/f9BfYA+QIB//f+/QD9/vwBC/0BAf4A/Az5+/8D+wD7/AAVCAT8BwICAwT+CAUE+/n0A/sJ/PgHAwEGCAj9+P8CC/75/Pv8/gUGAwT6/vcEBwDxAAEHAwAACgEE+voH"
---

Almost exactly a decade ago I worked at OkCupid Labs where small teams (~2 engineers, a designer, and a fractional PM) would build zero-to-one applications. It was great fun and I worked mainly on [Ravel!](https://island94.org/2013/07/Meet-Ravel.html) though bopped around quite a bit too.

With small teams and quick timelines, I learned a lot about where to invest time in early social apps (onboarding and core loop) and where not to (matchmaking algorithms). The following is lightly adapted from a bunch of comments I wrote on an r/webdev post a few years ago, asking for ["Surprisingly simple web apps?"](https://www.reddit.com/r/webdev/comments/pey1p7/comment/%2Chb4gik2%2C/). My response was [described](https://www.reddit.com/r/webdev/comments/pey1p7/comment/hb4gpxy/?utm_source=reddit&utm_medium=web2x&context=3) as "one of the more interesting things I've read on reddit in 5 years":

If you're looking for inspiration, what is successful today is likely more complex than it was when it was originally launched. Twitter, Tinder, Facebook all likely launched with simple CRUD and associations, and only later did they get fancy algorithms. Also, Nextdoor, Grindr, Yelp [this was 2013].

I used to work on social and dating apps and it is all "fake it till you make it". The "secret sauce" is bucket by distance intervals, then order by random using the user-id as a seed so it's determinist, but still just random sort. Smoke and mirrors and marketing bluster.

You see this "Secret Sauce" marketing a lot. An app will imply that they have some secret, complex algorithm that no other competitor has. The software equivalent of "you can get a hamburger from anywhere, but ours has our secret sauce that makes it taste best". But that can be bluster and market positioning rather than actually complexity. In truth, it's secretly mayo, ketchup and relish. Or as I've encountered building apps, deterministic random.

Imagine you have a dating/social app and you want to have a match-making algorithm. You tell your users that you have the only astrologist datascience team building complex machine-learning models that can map every astronomical body in the known universe to individual personality traits and precisely calculate true love to the 9th decimal.

In truth, you:

- For the current user, bucket other users by distance: a bucket of users that are less than 5km away; less than 25km; less than 100km; and everyone else. Early social app stuff is hard because you have a small userbase but you need to appear to be really popular, so you may need to adjust those numbers; also a reason to launch in a focused market.
- Within each distance bucket, simply sort the users by random, seeded by the user id of the current user (Postgres `setseed`). That way the other people will always appear in the same order to the current user.

It works on people's confirmation bias: if you confidently tell someone that they are a match, they are likely to generate their own evidence to support that impression. You don't even have to do the location bucketing either, but likely you want to give people something that is actionable for your core loop.

And remember, this is really about priorities in the early life of a product. It's not difficult to do something complex, but it takes time and engaged users to dial it in; so that's why you don't launch with a real algorithm.

This is all really easy to do with just a relational database _in the database_, no in-memory descent models or whatever. Here's a simple recommendation strategy for t-shirts (from my [Day of the Shirt](https://dayoftheshirt.com)), in SQL for Ruby on Rails:

For a given user, find all of the t-shirts they have favorited, then find all of the users that have also favorited those t-shirts and strength them based on who has favorited the most t-shirts in common with the initial user, and then find all of the t-shirts those users have favorited, multiply through the counts and strengths, sum and order them. There's your recommended t-shirts:

```ruby
class Shirts < ApplicationRecord
  # ...
  scope :order_by_recommended, lambda { |user|
    joins(<<~SQL.squish).order('strength DESC NULLS LAST')
      LEFT JOIN (
        WITH recommended_users AS (
          SELECT user_id, count(*) AS strength
          FROM favorite_shirts_users
          WHERE
            shirt_id IN (
              SELECT shirt_id
              FROM favorite_shirts_users
              WHERE #{sanitize_sql_for_conditions(['user_id = ?', user.id])}
            )
          GROUP BY user_id
        )
        SELECT shirt_id, SUM(strength) AS strength
        FROM favorite_shirts_users
        LEFT JOIN recommended_users ON recommended_users.user_id = favorite_shirts_users.user_id
        GROUP BY shirt_id
      ) AS recommended_shirts ON recommended_shirts.shirt_id = shirts.id
    SQL
  }
end
```

That's a relatively lightweight strategy, that you can run in real-time and if there is enough engagement can appear effective. And if you don't have enough engagement, again, enrich it with some deterministically random results.

It's basic but you can also add in other kinds of engagement and weigh them differently or whatever. It's all good. Then you have massive success and hire a real datascience team.
