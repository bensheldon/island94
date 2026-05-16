---
title: "Faster development by designing for the Rails Autoloader"
date: 2024-04-11 15:00 PDT
published: true
tags: []
---

_The following is a written version of the presentation I gave at the [SF Bay Area Ruby Meetup (with video recording)](https://island94.org/2024/04/a-ruby-meetup-and-3-podcasts) on April 4, 2024._

I'm the developer of GoodJob, a multithreaded, Postgres-based, ActiveJob backend for Ruby on Rails. I frequently come into contact with the following documentation, which the following post will make some sense of:

- [Rails Guides: The Rails Initialization Process](https://guides.rubyonrails.org/initialization.html)
- [Rails Guides: Autoloading and Reloading Constants](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html)
- [Rails Guides: Configuring Rails Applications: Initialization Events](https://guides.rubyonrails.org/configuring.html#initialization-events)
- [Rails API: `ActiveSupport::LazyLoadHooks`](https://edgeapi.rubyonrails.org/classes/ActiveSupport/LazyLoadHooks.html)

### An introduction

Working on GoodJob, I was once requested a feature like this:

> As a developer, I want GoodJob to enqueue Active Job jobs on a recurring basis so it can be used as a replacement for cron. Example interface:

...and I've seen examples of something similar that propose an interface like this:

```ruby
class MyRecurringJob < ApplicationJob
  repeat_every 1.hour
  # or
  with_cron "0 * * * *"

  def perform
  # ... ...
end
```

That sure would be a nice way to do it 💅

**But I did NOT do it that way in GoodJob!** I did it like this instead:

```ruby
# config/application.rb or config/initializers/good_job.rb
config.good_job.cron = {
  recurring_job: {
    cron: "0 * * * *",
    class: "MyRecurringJob", # a String, not the constant 😰
  }
}
```

To be clear about the difference: the configuration doesn't live with the job, it lives in the Rails `config/` directory. And when the application initially boots and loads GoodJob, this is how GoodJob initializes it:

```ruby
# in the GoodJob gem...
ActiveSupport.after_initialize do
  config.good_job.cron.each do |_, config|
    when_scheduled(config[:cron]) do
      # only do this at the scheduled time
      config[:class].constantize.perform_later
    end
  end
end
```
**But why? 😭**

- We want our Rails application to boot really fast in Development.
- Loading files and constants, just to read configuration inside of them, is slow.
- Rails goes to a lot of trouble to defer loading files and constants, because that's fast.
- The mechanism is called **Autoloading**, which is built into Ruby (`autoload`) and via the Zeitwerk library (Rails uses both).
- This all largely happens behind the scenes, and we largely don't think about it.
- Let's not mess that up.

A brief clarification about the context here:


-  I'm specifically talking about **Development** workflows, where code is **Autoloaded**
- In Production, Rails will (mostly) **Eagerly Autoload** these files/constants instead of _lazily_ autoloading them.
    - `config.cache_classes = true`
    - `config.eager_load = true`
- Remember, we're talking here about **Development**, where we want fast feedback from code changes and not ⏳

### Application Structure

![](/uploads/2024/autoloading/config-behavior.svg)

---

# Break it down

- **Configuration** is `require`'d during boot.
- **Behavior** is autoloaded
    - Only load what is needed when it's needed, _ideally_ never.
    - To serve a single web request, to run that one test, to open the console, and code reload.

![bg right 100%](images/config-behavior.svg)
