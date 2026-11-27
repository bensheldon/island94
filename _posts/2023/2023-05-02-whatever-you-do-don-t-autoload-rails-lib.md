---
title: "Whatever you do, don't autoload Rails `lib/`"
date: 2023-05-02 07:09 PDT
published: true
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "2a24baaff5b344c0"
  vector: "9Pb//gIB/wf8AgEM/gYCBQn8/QwCBgEL/vP++QH3BQj9AQL+Bv34/wYE/Qfz/AX4AP4FAPwA/QD/Af8O/hL7AAIG/QUEBAEE+wAB9/4D+PT6/AYIAP0A/A7/B/cOBwUBCQP7A/v/BQUDAf4F/foI/QX5BPwA+wIH/gYIAQX8+AD+A/kR9fv8A/8BBAr7BAb/+QIEA/sA9wL/Dg8A/QIF/AUG/gj8BPf6BQj0AQv+BgP59wQBBxH3/Pf1B/IQ+vcFAPoC/gkC+/0AAv/7/QH6BAL3AAAC/gj39gIKAAACAQAK+P4ECAH9/AH59QAG+AT5/PoCBvAG/gIE/+wA+wABCP7u7AbyBQr5Df37/Pv/+v///f//AvcIDAMD/AgDCQHy7PP+AAj/+Qv8Av8ABAD8+PX+/wj6/P4B/QMDBf0H9wABCAAC+wIFDwMJAf31C/MDBATyBf4EBAb9/QH9A/4CC/j/AAkB/gcBAf4H/Pn1+/n5BPgI9gMKBwL3Af4B9/sB"
---

_**Update:** Rails v7.1 will introduce a new configuration method [`config.autoload_lib`](https://github.com/rails/rails/pull/48572) to make it safer and easier to autoload the `/lib` directory and explicitly exclude directories from autoloading. When released, this advice may no longer be relevant, though I imagine it will still be possible for developers to twist themselves into knots and cause outages with autoloading overrides._  

One of the most common problems I encounter consulting on Rails projects is that developers have previously added `lib/` to autoload paths and then twisted themselves into knots creating error-prone, project-specific conventions for subsequently un-autoloading a subset of files also in `lib/`.

*Don't do it. Don't add your Rails project's `lib/` to autoload paths.*

### How does this happen?

A growing Rails application will accumulate a lot of ruby classes and files that don't cleanly fit into the default `app/` directories of `controllers`, `helpers`, `jobs`, or `models`. Developers should also be creating new directories in `app/*` to organize like-with-like files (your `app/services/` or `app/merchants/`, etc.). That's ok!

But frequently there are one-off classes that don't seem to rise to the level of their own directory in `app/`. From looking through the cruft of projects like [Mastodon](https://github.com/mastodon/mastodon/tree/c62604b5f69c3ad7f5449e0a7dc26606adebb777/app/lib) or applications [I've](https://github.com/codeforamerica/vita-min/tree/2f5faf06f586d1ea3915af262aab7683240f4727/app/lib) [worked](https://github.com/bensheldon/open311status/blob/2cd70e391770f64d734f462624222fb8f8bc14a4/app/lib/service_requests_pager.rb) [on](https://github.com/bensheldon/open311status/tree/2cd70e391770f64d734f462624222fb8f8bc14a4/app/lib), these files look like:

- A lone form builder
- POROs ("Plain old Ruby objects") like `PhoneNumberFormatter`, or `ZipCodes` or `Seeder`, or `Pagination`. Objects that serve a single purpose and are largely singletons/identity objects within the application.
- Boilerplate classes for 3rd party gems, e.g. `ApplicationResponder` for the `responders gem`.

That these files accumulate in a project is a fact of life. When choosing where to put them, that's when things can go wrong.

In a newly built Rails project `lib/` looks like the natural place for these. But `lib/` has a downside: `lib/` is not autoloaded. This can come as a surprise, even to experienced developers, because they have been accustomed to the convenience of autoloaded files in `app/`. It's not difficult to add an explicit `require` statement into `application.rb` or in an initializer, but that may not be one's first thought.

That's when people jump to googling "how to autoload `lib/`". Don't do it! `lib/` should not be autoloaded.

The problem with autoloading `lib/` is that there will subsequently be files added to `lib/` that should _not_ be autoloaded; because they should only be provisionally loaded in a certain environment or context, or deferred, for behavioral, performance, or memory reasons. If your project has already enabled autoloading on `lib/`, it's now likely you'll then add additional configuration to un-autoload the new files. These overrides and counter-overrides accumulate over time and become difficult to understand and unwind, and they cause breakage because someone's intuition of what will or won't be loaded in a certain environment or context is wrong.

What should you do instead?

### An omakase solution

DHH [writes](https://github.com/rails/rails/pull/47843#issuecomment-1515367267):

>  `lib/` is intended to be for non-app specific library code that just happens to live in the app for now (usually pending extraction into open source or whatever). Everything app specific that's part of the domain model should live in `app/models` (that directory is for POROs as much as ARs)... Stuff like a generic PhoneNumberFormatter is exactly what `lib/` is intended for. And if it's app specific, for some reason, then `app/models` is fine.

The omakase solution is to manually require files from `lib/` or use `app/models` generically to mean "Domain Models" rather than solely Active Record models. That's great! Do that.

### A best practice

Xavier Noria, Zeitwerk's creator [writes](https://github.com/rails/rails/issues/37835#issuecomment-757367812):

> The best practice to accomplish that nowadays is to move that code to `app/lib`. Only the Ruby code you want to reload, tasks or other auxiliary files are OK in `lib`.

Sidekiq's Problems and Troubleshooting [explains](https://github.com/sidekiq/sidekiq/wiki/Problems-and-Troubleshooting#autoloading):

> A `lib/` directory will only cause pain. Move the code to `app/lib/` and make sure the code inside follows the class/filename conventions.

The best practice is to create an `app/lib/` directory to home these files. [Mastodon](https://github.com/mastodon/mastodon/tree/c62604b5f69c3ad7f5449e0a7dc26606adebb777/app/lib) does it, as do [many others](https://github.com/search?type=code&auto_enroll=true&q=path%3A%2F%5Eapp%5C%2Flib%5C%2F.*%5C.rb%2F).

This "best practice" is not without contention, as usually anything in Rails that deviates from omakase does, like RSpec instead of MiniTest or FactoryBot instead of Fixtures. But creating `app/lib` as a convention for Rails apps works for me and many others.

### Really, don't autoload `lib/`

Whatever path you take, don't take the path of autoloading `lib/`.
