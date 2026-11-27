---
title: "How to isolate I18n configuration in a Rails Engine"
date: 2023-08-22 06:54 PDT
published: true
tags:
- GoodJob
- Ruby on Rails
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "e1f07312cf2db1f8"
  vector: "+v7//P0DAQH7/P4AAgUAAQoG/PkGAgsIAPf//P79/Aj7BAkLBPj8AQMA//cA/QgB/AH7/gL2AQAE//0I+gz+/v//+gj9AAD++QT5/AEA+PQAAgoDB/gG+RAD/vQICAn8CQz9A/79CQD2/wAI/PcHA/4GA/0I+gMC/AoBBf0EAAABBf4I+gL8/QD9Bgz+/P8AAQsNDwgD+vkBAgT7+f//+QMIB/gD/vYAAQX2AAcBAv8H+P38BwMAAwsEB/T/9/0EB/kIBQ328wYECgH6/QAAAP4C8wUJBAkAAwEA+/z9AwAM7AMJ/voMCgf4//QE/AX4/AEFBvUB+QUI//IA+P3/AP4C6wTz/wEJCQL5/vUO+/ju/QX49PoA+Qf3+fsBAwP7+fkDAAr3Cfb/BwUCA/4E/PH9/P4ICPkPBwIDAvcD9wD5A/gI+PgBCgQG/vz2+fgABBL9BAMLBAL8BfMACPcH/v8J+AL1AwUACQD3+f769v0A+/b++wkGBAXzBwX99voA"
---

[GoodJob](https://github.com/bensheldon/good_job) is a multithreaded, Postgres-based, Active Job backend for Ruby on Rails.

GoodJob includes an administrative web dashboard that is packaged as a mountable Rails Engine. The dashboard is currently translated into 8 different languages: English, German, Spanish, French, Japanese, Dutch, Russian, Turkish, and Ukrainian (I'd love your help improving these and translating additional languages too). Demo here: [https://goodjob-demo.herokuapp.com/](https://goodjob-demo.herokuapp.com/)

I have learned quite a lot during the GoodJob development process about internationalizing a Rails Engine. I've previously worked on rather large and complicated localized government welfare applications, so I'm familiar with localization in the context of a Rails app. But internationalizing a Rails Engine was new, getting it right was harder than I expected, and I had trouble finding documentation and code examples in other libraries.

Overall, internationalizing a Rails Engine was _nearly_ identical to the process of internationalizing a Rails Application as covered in the [Rails Guides](https://guides.rubyonrails.org/i18n.html): using the `I18n` library and extracting strings from ERB views into keyed configuration files (e.g. `config/locales/en.yml`) and replacing them with `<%= t(".the.key") %>` . Simple.

The difficult part was separating and isolating GoodJob's `I18n` configuration from the parent applications.

### Why is it necessary to isolate `I18n`?

As a mountable Rails Engine, GoodJob's dashboard sits _within_ a parent Rails application. GoodJob should step lightly.

The `I18n` library provides a number of configuration options:

- `I18n.current_locale`
- `I18n.default_locale`
- `I18n.available_locales`
- `I18n.enforce_available_locales` , which will raise an exception if the locale is switched to one not contained within the set of available locales.

It's possible that GoodJob's administrative web dashboard would have different values for these than the parent Rails Application. Imagine: An English and Ukrainian speaking development and operations team administering a French and German language only website. How to do it?

### Isolating configuration values

`I18n` configuration needs to be thread-local, so that a multithreaded webserver like Puma can serve a web request to the GoodJob Dashboard in Ukrainian (per the previous scenario) while _also_ serving a web request for the parent Rails application in French (or raise an exception if someone tries to access it in Italian).

Unfortunately, `I18n.current_locale` is the only configuration value that delegates to a thread-locale variable. All other configuration values are [implemented as global `@@` class variables](https://github.com/ruby-i18n/i18n/blob/7cf09474b77fd41e65d979134b0525f67cf371b0/lib/i18n/config.rb#L58) on `I18n.config`. This makes sense when thinking of a monolithic application, but not when a Rails application is made up of multiple Engines or components that serve different purposes and audiences (the frontend visitor and the backend administrator). I struggled _a lot_ figuring out a workaround for this, until I discovered that `I18n.config` is _also_ thread-local.

**Swap out the entire `I18n.config` value with your Engine's own `I18n::Config`-compatible object:**

```ruby
# app/controllers/good_job/application_controller.rb
module GoodJob
  class ApplicationController < ActionController::Base
    around_action :use_good_job_locale

    def use_good_job_locale(&action)
      @original_i18n_config = I18n.config
      I18n.config = ::GoodJob::I18nConfig.new
      I18n.with_locale(current_locale, &action)
    ensure
      I18n.config = @original_i18n_config
      @original_i18n_config = nil
    end
  end
end

# lib/good_job/i18n_config.rb
module GoodJob
  class I18nConfig < ::I18n::Config
    BACKEND = I18n::Backend::Simple.new
    AVAILABLE_LOCALES = GoodJob::Engine.root.join("config/locales").glob("*.yml").map { |path| File.basename(path, ".yml").to_sym }.uniq
    AVAILABLE_LOCALES_SET = AVAILABLE_LOCALES.inject(Set.new) { |set, locale| set << locale.to_s << locale.to_sym }

    def backend
      BACKEND
    end

    def available_locales
      AVAILABLE_LOCALES
    end

    def available_locales_set
      AVAILABLE_LOCALES_SET
    end

    def default_locale
      GoodJob.configuration.dashboard_default_locale
    end
  end
end
```

Here's the PR with the details that also shows the various complications I had introduced prior to finding this better approach: [https://github.com/bensheldon/good_job/pull/1001](https://github.com/bensheldon/good_job/pull/1001)

### Isolating Rails Formatters

The main reason I implemented GoodJob's Web Dashboard as a Rails Engine is because I want to take advantage of all of Rail's developer niceties, like time and duration formatters. These are also necessary to isolate, so that GoodJob's translations don't leak into the parent application.

First, time helper translations should be namespaced in the yaml translation files:

```yaml
# config/locales/en.yml
good_job:
  # ...
  datetime:
    distance_in_words:
    # ...
  format:
    # ...
  # ...
```

Then, for each helper, here's how to scope them down:

- `number_to_human(number, unit: "good_job.number")`
- `time_ago_in_words(timestamp, scope: "good_job.datetime.distance_in_words")`

By the way, there is a great repository of translations for Rails helpers here: [https://github.com/svenfuchs/rails-i18n/tree/64e3b0e59994cc65fbc47046f9a12cf95737f9eb/rails/locale](https://github.com/svenfuchs/rails-i18n/tree/64e3b0e59994cc65fbc47046f9a12cf95737f9eb/rails/locale)

### Closing thoughts

Whenever I work on internationalization in Rails, I have to give a shoutout for the [`i18n-tasks` library](https://github.com/glebm/i18n-tasks), which has been invaluable in operationalizing translation workflows: surfacing missing translation, normalizing and linting yaml files, making it easy to export the whole thing to a spreadsheet for review and correction, or using machine translation to quickly turn around a change (I have complicated feelings on that!).

Internationalizing GoodJob has been a fun creative adventure. I hope that by writing this that other Rails Engine developers prioritize internationalization a little higher and have an easier time walking in these footsteps. And maybe we'll make the ergonomics of it a little easier upstream too.
