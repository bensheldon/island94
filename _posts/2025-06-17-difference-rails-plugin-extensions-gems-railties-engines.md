---
title: "The difference between Rails Plugins, Extensions, Gems, Railties, and Engines"
date: 2025-06-17 15:48 UTC
published: true
tags: [Rails, "Rails Engines"]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "8c01f12778bd29a3"
  vector: "8fb6BgAE/Qz0/v8IAAQCBhMA+gQJAwQI9fn6Avz4A/7/Av8DDPz4/gL++gMD/QH4+Pz//wH+//38/f0I/AwA/vr/9QAG+v77+P/39wQE9fv5/f4CAQYG9wQC//cKBgT7CPwAAP4EAwX8BvYJ//YFAAH9BP73+AkDAQkNA/4A+AD7A/YQ+AT3A/8HAQ8BBQcB9gMKBPsM+gUIBAH+/QIEAgUAAv8A+/j4AQPy+wYBBwP//gP9GBD8+gECCfoB+/cEAgIDAgUF/gj3Bwf0/gP2B/j++f79/wb+AAP8APkKDQAN9wAMAvsE9P/5+f8J+wj39PEECvcE+PwNBOoB/vcCBQL17Qz5Awb2Bf78BAEHAPsAA/79APsG//8G+QgRAQH77vcC/Ab8/wUGAv//AgD9+Pj9BQEBBPwFAPwFA/oB8wAIBQD9+wIIBfsDBgX3CQH+/P38CAAF/Aj2+P78B/0LBgQGAQb8BgT6AwAC/f8E9vT8AvgF+gcDCQb2//oA9AUB"
---

There’s overlapping terminology that describes the act of packaging up some new behavior for Rails. I think of two gems I maintain that are of vastly different scales

- [`activerecord-has_some_of_many`](https://github.com/bensheldon/activerecord-has_some_of_many) which adds two new tiny association methods to Active Record models in 150 lines of code.
- [GoodJob](https://github.com/bensheldon/good_job), which is an entire Active Job backend with a mountable Web Dashboard and database models and custom job extensions in 10k lines of code.

I was pondering the different terminology because I recently saw both ends of the spectrum discussed in the community:

- A developer on Reddit announced a tiny new gem and a commenter wrote _well actually, in your Readme you called it an Engine but you shouldn’t do that._
- I got pinged on [a Rails issue](https://github.com/rails/rails/issues/52311) that left me with the belief that some behavior, if _not_ packaged as an Engine, could be expected to break.

I think there are only two dimensions to consider when picking the correct terminology:

- How the behavior is packaged
- Whether it’s necessary to package the behavior that way. Which isn’t even a criticism in my opinion, just an observation.

Here’s my opinionated list, in order of somewhat increasing complexity:

- **Rails Extension**: A small monkeypatch or tiny new behavior to existing Rails behaviors (Active Record, Active Job, etc.). Especially if it's not even a gem: simply a file you wrote a blog post about that gets copied into `config/extensions` and then `require_relative`’d in `config/application.rb`.
- **Rails Gem** : Reductively, a gem is a load path for some code, and some ownership metadata, and maybe it's been published to Rubygems.org. Nothing special.
- ⭐️ **Rails Plugin**. A generic name covers all situations imo, regardless of size, scope, or complexity.
- **Railtie**: When you write a gem that plugs into the Rails framework, you create [special file](https://api.rubyonrails.org/classes/Rails/Railtie.html) named `lib/railtie.rb` that has a class that inherits from `[Rails::Railtie](https://api.rubyonrails.org/classes/Rails/Railtie.html) that contains a DSL to configure how your gem’s behavior interfaces with Rails (configuration, initialization, etc.). I think Railtie is a bit of an odd-duck terminology-wise, but it makes sense considering…
- **Rails Engine**: An “Engine” is _nearly_ identical to a Railtie, but the file is named `lib/engine.rb` and it has a class that inherits from `Rails::Engine`. But `Rails::Engine` itself inherits from `Rails::Railtie`, so this is a matter of degrees. Your gem absolutely _needs_ to use the Engine behavior if it wants to create mountable routes (though I guess you can mount a vanilla Rack app) or inherit from Rails Base classes like `ActiveRecord::Base`, `ActionController::Base`, `ActiveJob::Base`, etc. which live in the Engine’s own `app/` directory.

(I’ll clock that the [The Rails Guides](https://guides.rubyonrails.org/), under the “Extending Rails” section, has separate guides for Plugins and Engines; the former somewhat surprisngly does not mention the latter.)

So if I go back to the two reasons why I wrote this, and try to be strict with this terminology:

- If your Plugin _has_ an `engine.rb` file, it _is_ an Engine. Simple as that. If you don’t need the Engine-specific behavior, you could package it as a Railtie, but I think the difference is negligible.
- If you don’t have _any_ dependencies on Rails (outside of maybe ActiveSupport) and don’t need to hook into the parent application’s configuration or initialization or framework, then you don’t need a Railtie or Engine at all. Just say it’s a gem that’s compatible with Rails and explain how to use it in that environment.
- Really, do what you want and tell people about it.
