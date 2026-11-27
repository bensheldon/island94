---
title: "How GoodJob's mountable Rails Engine delivers Javascript importmaps and frontend assets"
date: 2023-03-20 08:27 PDT
published: true
tags: [GoodJob]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "19b97bb948317675"
  vector: "8P/7BQsA+gb2AP8KBgAFBgoD//4A/gn+/fkA/v70Bvz1/gAQBvP7/wQK9Pn/7wT1/gD6/v/2+P/99QANAgQE+Qb/+An+CPz++fn69wAD/fH39gILBAL9/g0A+/kLCAEDAgf4Cvz8DAACAwAL+/sGBv0AAQEF+AQJExENBQj6/QAEBf0M/AP8/vYLARL7BQH8/QMO/f3++AcGCAIF+AIHBQQEBQH2APn+Av76AP/8AgUD+/kFDwb6+f//CvgD+fcC+fwDCwT/+gwHBAPz+gf+Af749gIH/wIBAgn////7AQAL/P8NBP0KAQH+/P0G+AUC9QAD+/UN/QUGBer/8QX8BP32+gH0BwL9Cf39BP4G/vr8/f76+/cC+wH9+AkC/AX4+/D6Bgv7/P0JAQYCCf0B/fr8/gICA/gGAP7+BAIA/QD+Bvr9/wEABwEDBwH2APX//hD6+v4KBQkC//33Bv3+/f8E+P/+AQUAAAf4/Pj+9vz8Avf8/AgD/wn4AP0E8gD+"
---

[GoodJob](https://github.com/bensheldon/good_job) is a multithreaded, Postgres-based ActiveJob backend for Ruby on Rails.

GoodJob includes a full-featured (though optional) web dashboard to monitor and administer background jobs. The web dashboard is included in the `good_job` gem as a mountable Rails Engine.

As the maintainer of GoodJob, I want to make gem development easier for myself by innovating as little as possible. That’s why GoodJob builds on top of Active Record and Concurrent::Ruby.

But, the frontend can be a beast. When thinking about how to build a full-featured web dashboard *packaged within a Rails Engine within a gem*, I had three goals:

1. **Be asset pipeline agnostic with zero dependencies.** As of Rails ~7.0, a Rails developer can choose between several different asset pipeline tools (Sprockets, Webpacker/Shakapacker, esbuild/jsbundling, etc.). That’s too many! I want to ensure what I package with GoodJob is compatible with all of them. I also don’t want to affect the parent application at all; everything must be independent and self-contained.
2. **Allow easy patching/debugging.** I want the GoodJob web dashboard to work when using the Git repo directly in a project’s Gemfile or simply `bundle open good_job` to debug a problem.
3. **Write contemporary frontend code.** I want to use Bootstrap UI, Stimulus, Rails UJS, and write modular JavaScript with imports. Maybe even Turbo!

And of course, I want GoodJob to be secure, performant, and a joy to develop and use for myself and the developer community.

Read on for how I achieved it all (mostly!) with GoodJob.

## What I didn’t do

Here’s all the things I considered, but decided not to do:

- **Nope: Manually construct/inline a small number of javascript files**: I did not want to manually build a javascript file, copy-pasting various various 3rd-party libraries into a single file, and then writing my code at the bottom. This seemed laborious and prone to error, especially when I would need to update a library; and my IDE doesn’t work well with large files so writing my own code would be difficult.
- **Nope: Precompile javascript in the repository or on gem build:** I did not want to force a pre-commit step to build javascript, or to only package built javascript into the gem because that would make patching and debugging difficult. Over my career I’ve struggled contributing to a number of otherwise fantastic gems that use this workflow pattern.
- **Nope: Compile javascript in the application:** Rails has too many different asset pipeline patterns right now for me to consider supporting them all. I consider this more a result of a highly fragmented frontend ecosystem than an indictment of Rails. I can’t imagine supporting all of the different options and whatever else shows up in the future at the same time. (I’m in awe of the gems that do; nice work `rails_admin`!)

## What I did do

As I wrote earlier: “innovate as little as possible”:

**Serve vanilla JS and CSS out of vanilla Routes/Controller**

GoodJob has explicit routes for frontend assets that wire up to a controller that serves those assets statically with `render :file`. Let’s break that down…

In my Rails Engine’s router, I define a namescape, `frontend`, and two `get` routes. The first route, `modules` , is for Javascript modules that will go into the importmap. The second route, `static` , is for Javascript and CSS that I’ll link/script directly in the HTML head.

```ruby
# config/routes.rb
scope :frontend, controller: :frontends do
  get "modules/:name", action: :module, as: :frontend_module, constraints: { format: 'js' }
  get "static/:name", action: :static, as: :frontend_static, constraints: { format: %w[css js] }
end
```

In the matching controller, I create static constants that define hashes of files that are matched and served, which I store in a `app/frontend` directory in my Rails Engine. *I want paths to be explicit for security reasons because passing any sort of dynamic file path through the URL could be a path traversal vulnerability.* All of the frontend assets are stored in `app/frontend` and served out of this controller:

```ruby
# app/controllers/good_job/frontends_controller.rb

module GoodJob
  class FrontendsController < ActionController::Base # rubocop:disable Rails/ApplicationController
    STATIC_ASSETS = {
      css: {
        bootstrap: GoodJob::Engine.root.join("app", "frontend", "good_job", "vendor", "bootstrap", "bootstrap.min.css"),
        style: GoodJob::Engine.root.join("app", "frontend", "good_job", "style.css"),
      },
      js: {
        bootstrap: GoodJob::Engine.root.join("app", "frontend", "good_job", "vendor", "bootstrap", "bootstrap.bundle.min.js"),
        chartjs: GoodJob::Engine.root.join("app", "frontend", "good_job", "vendor", "chartjs", "chart.min.js"),
        es_module_shims: GoodJob::Engine.root.join("app", "frontend", "good_job", "vendor", "es_module_shims.js"),
        rails_ujs: GoodJob::Engine.root.join("app", "frontend", "good_job", "vendor", "rails_ujs.js"),
      },
    }.freeze

		# Additional JS modules that don't live in app/frontend/good_job/modules
    MODULE_OVERRIDES = {
      application: GoodJob::Engine.root.join("app", "frontend", "good_job", "application.js"),
      stimulus: GoodJob::Engine.root.join("app", "frontend", "good_job", "vendor", "stimulus.js"),
    }.freeze

    def self.js_modules
      @_js_modules ||= GoodJob::Engine.root.join("app", "frontend", "good_job", "modules").children.select(&:file?).each_with_object({}) do |file, modules|
        key = File.basename(file.basename.to_s, ".js").to_sym
        modules[key] = file
      end.merge(MODULE_OVERRIDES)
    end

    # Necessarly to serve Javascript to the browser
		skip_after_action :verify_same_origin_request, raise: false
    before_action { expires_in 1.year, public: true }

    def static
      render file: STATIC_ASSETS.dig(params[:format].to_sym, params[:name].to_sym) || raise(ActionController::RoutingError, 'Not Found')
    end

    def module
      raise(ActionController::RoutingError, 'Not Found') if params[:format] != "js"

      render file: self.class.js_modules[params[:name].to_sym] || raise(ActionController::RoutingError, 'Not Found')
    end
  end
end
```

One downside of this is that I’m unable to use Sass or Typescript or anything that isn’t vanilla CSS or Javascript. So far I haven’t missed that too much; Bootstrap brings a very comprehensive design system and Rubymine is pretty good at hinting Javscript on its own.

Another downside is that I package several hundred kilobytes of frontend code within my gem. This increases the gem size, which is a real bummer if an application isn’t mounting the dashboard. I’ve considered separating the optional dashboard into a separate gem, but I’m deferring that until anyone notices that it’s problematic (so far so good!).

**Manually link assets and construct a JS importmaps in my Engine’s layout `<head>`**

Having created the routes and controller actions, I can simply link the static files in the layout html header:

```html
<!-- app/views/layouts/good_job/application.html.erg -->
<head>
  <!-- ... -->
  <%# Note: Do not use asset tag helpers to avoid paths being overriden by config.asset_host %>
  <%= tag.link rel: "stylesheet", href: frontend_static_path(:bootstrap, format: :css, v: GoodJob::VERSION, locale: nil), nonce: content_security_policy_nonce %>
  <%= tag.link rel: "stylesheet", href: frontend_static_path(:style, format: :css, v: GoodJob::VERSION, locale: nil), nonce: content_security_policy_nonce %>

  <%= tag.script "", src: frontend_static_path(:bootstrap, format: :js, v: GoodJob::VERSION, locale: nil), nonce: content_security_policy_nonce %>
  <%= tag.script "", src: frontend_static_path(:chartjs, format: :js, v: GoodJob::VERSION, locale: nil), nonce: content_security_policy_nonce %>
  <%= tag.script "", src: frontend_static_path(:rails_ujs, format: :js, v: GoodJob::VERSION, locale: nil), nonce: content_security_policy_nonce %>
```

Beneath this, I manually construct the JSON the browser expects for importmaps:

```html
<!-- Link es_module_shims -->
<%= tag.script "", src: frontend_static_path(:es_module_shims, format: :js, v: GoodJob::VERSION, locale: nil), async: true, nonce: content_security_policy_nonce %>

<!-- Construct the importmaps JSON object -->
<% importmaps = GoodJob::FrontendsController.js_modules.keys.index_with { |module_name| frontend_module_path(module_name, format: :js, locale: nil, v: GoodJob::VERSION) } %>
<%= tag.script({ imports: importmaps }.to_json.html_safe, type: "importmap", nonce: content_security_policy_nonce) %>

<!-- Import the entrypoint: application.js -->
<%= tag.script "", type: "module", nonce: content_security_policy_nonce do %> import "application"; <% end %>
```

### That’s it!

I’ll admit, serving frontend assets using `render file:` is boring, but I experienced a thrill the first time I wired up the importmaps and *it just worked*. Writing small Javascript modules and using `import` directives is really nice. I recently added Stimulus and I’m feeling optimistic that I could reliably implement Turbo in my gem’s Rails Engine fully decoupled from the parent application.

I hope this post about GoodJob inspires you to build full-featured web frontends for your own gems and libraries.
