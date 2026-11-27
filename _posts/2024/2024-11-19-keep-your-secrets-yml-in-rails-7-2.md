---
title: "Keep your secrets.yml in Rails 7.2+"
date: 2024-11-19 16:13 PST
published: true
tags: []
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "9b4344014aeb3402"
  vector: "+AL6/wH6/QYBAwAFAwILCgQEA/wI/AkIAvMDCPUCBv77AgAEBwP/+wAB9gT2AgX9+/4DAfkD9gIBAgEGCgYD//UF+QUM+/8D+PD5Afr1+f7+/AAH/gAD9wMCCvEGAQYF/wDy/f33BPgPBwX5BgcDBAIGBhD3DAEOCQgHBvr5/gAECPwK9wMK+f8E9/79+/kF+gsRBAgB/vwG/gMD/AIEAAgGBv8KBfv3A/7++gP/BAMOAvb6+/j99Aj9Ae77/f75APwA/gIG9Qb8/vL5AgYDBQgF7hL7CQUD/wgMAAX89AD/9gIHBQIDBP/6+QMA9Ar7/QL8/ewA+AUL//cE/vwACvL+7fX4AgT7DP/7/P7+B/b+BQT1//cGBfwIA/4HBgMG9gT4DAAC//oG+wb19fv6CgMB+v8K/P4J/gT9APsDCAADBQQC+QUCAv8BA/r6B/n7+/0B9/3/+AIFBf0GBgYC9QAB9wj8/QEC//0FAff7CwEA/vr9/AsHBv/+Afj++/n5"
---

Ruby on [Rails v7.1 deprecated and v7.2 removed](https://www.shakacode.com/blog/rails-7-1-removes-secret-setup-command-and-deprecates-secret-show-edit-commands/) support for `Rails.application.secrets` and `config/secrets.yml` in favor of Encrypted Credentials. You don't have to go along with that! I like Secrets functionality because it allows for consolidating and normalizing `ENV` values in a single configuration file with ERB (Encrypted Credentials [doesn't](https://github.com/rails/rails/pull/46508)).

It's extremely simple to reimplement the same behavior using [`config_for`](https://guides.rubyonrails.org/configuring.html#custom-configuration) and the knowledge that methods defined in `application.rb` show as methods on `Rails.application`:

```ruby
# config/application.rb

module ExampleApp
  class Application < Rails::Application
    # ....
    config.secrets = config_for(:secrets) # loads from config/secrets.yml
    config.secret_key_base = config.secrets[:secret_key_base]

    def secrets
      config.secrets
    end
  end
end
```

That is all you need to continue using a `secrets.yml` file that looks like this:

```yaml
# config/secrets.yml

defaults: &defaults
  default_host: <%= ENV.fetch('DEFAULT_HOST', 'localhost:3000') %>
  twilio_api_key: <%= ENV.fetch('TWILIO_API_KEY', 'fake') %>
  mailgun_secret: <%= ENV.fetch('MAILGUN_SECRET', 'fake') %>

development:
  <<: *defaults
  secret_key_base: 79c6d24d26e856bc2549766552ff7b542f54897b932717391bf705e35cf028c851d5bdf96f381dc41472839fcdc8a1221ff04eb4c8c5fbef62a6d22747f079d7

test:
  <<: *defaults
  secret_key_base: 0b3abfc0c362bab4dd6d0a28fcfea3f52f076f8d421106ec6a7ebe831ab9e4dc010a61d49e41a45f8f49e9fc85dd8e5bf3a53ce7a3925afa78e05b078b31c2a5

# Do not keep production secrets in the repository,
# instead read values from the environment.
production:
  <<: *defaults
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
  default_host: <%= ENV['DEFAULT_HOST'] || (ENV['HEROKU_APP_NAME'] ? "#{ENV['HEROKU_APP_NAME']}.herokuapp.com": nil) %>
```

**Note:** This only works for `secrets.yml` not `secrets.enc.yml` which was called "Encrypted Secrets." If you're using "Encrypted Secrets" then you should definitely move over to the Encrypted Credentials feature.
