---
title: Running code when the Ruby on Rails webserver boots
date: 2026-07-31 18:43 UTC
published: true
tags: ["Ruby on Rails"]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "9150185cdff4dc25"
  vector: "9PrzAAH6/gP2BgQM/AEBABD1BwYC/v8C9Pn6/f/1Av37AAMMCPj4AwoA+gX9+QT7//YCAgb7/vP/9AMFBQgA/QACAAcKBP398P77/wX+8vf0+v0G/Qb//Q/9Bf8AA/sFAAT7BgD6BwAC/f0M//j/BAcIBgML+wQJBg4FAwEB/wADA/kF+wL7+QIJAwcB+wj9/QEOAgAA9QYFAwX/AQIIAQMGB/7+AvDyAwHsBgP3+wUE9f8GEw/4/QT8CPsF9PgCBfj+AQYF9gH+BgD3+wT6AwP/9wICAAn6/gL8AP//CQAK8QcOA/8G/AH6/v4FAgYB+fj+BvgK/wb9A/YE8vUDBQT77Qb/E///Ev76AfsE+//2A/wCB/0I/AD/+goG/gH3+PUB/gX+/QQABAQD//f8AfD9/QYE/v4FBfb9/vX79wAFAwAHAwoE/f0GBAP8Af4CAwL4//oCAgz6AAD7A/4FBAQH/Q73AwQCAQb8/PsD8/7//fX+/AoBBgbxAAcJ8foD"
---

I was recently part of a [Mastodon discussion](https://github.com/mastodon/mastodon/pull/39990) about the best way to run code in a Rails application before Puma boots. The need for this is that sometimes you want some code that _only_ runs within a webserver, not when running rake tasks or rails commands or opening the console.

Here we go…

### Via `server do` blocks

Rails 6.1 added a [`Railtie#server` hook](https://github.com/rails/rails/pull/39953) that can be invoked in `application.rb` or a gem’s `engine.rb`. It’s invoked when the `config.ru` file is evaluated.

**Warning:** the invocation of the hook in `config.ru` is missing from _a lot_ of Rails projects. I once [lackadaisically tried to address this upstream](https://github.com/rails/rails/pull/49704), but doublecheck your `config.ru` actually contains `Rails.application.load_server` as [it should](https://github.com/rails/rails/blob/b83739f81cc9f0f8028d98e1a3d7f6f79c375fb5/railties/lib/rails/generators/rails/app/templates/config.ru.tt#L6).

### In your `config.ru`

The Rackup configuration file only gets evaluated by a webserver, so that is a natural place to invoke your webserver-only code.

**Aside:** like `boot.rb`, I either find *interesting things* lurking around in `configu.ru` , or it’s one of those files that hasn’t been touched since `rails new` was first run.

### As a Puma plugin

If you’re dedicated to Puma, [write a simple plugin for it](https://github.com/puma/puma/blob/b8341dc946f0a2444e5ea6730d1967ca53c8d006/docs/plugins.md). Puma plugins also allow hooking into more sophisticated places than simply “before it starts”.

tbh, I wasn’t aware of Puma plugins as an integration point until [Solid Queue shipped a Puma plugin](https://github.com/rails/solid_queue/blob/86f3d92f1dd68547ec0ebe960fc9933c203d9e51/lib/puma/plugin/solid_queue.rb) for its in-webserver mode. I like it!

### By searching the callstack

I just mentioned Solid Queue has having an admirable integration point. My GoodJob has an… ok one: [searching the callstack for webserver fingerprints](https://github.com/bensheldon/good_job/blob/81db22b7cfde2579b2d735e076fa6eaacc65affa/lib/good_job/configuration.rb#L408-L418). I chose this path at the time for the broadest zero-configuration compatibility with older versions of Rails, different webservers, and JRuby, but I wouldn’t recommend it very strongly today because it feels brittle:

```ruby
def in_webserver?
  return @_in_webserver unless @_in_webserver.nil?

  @_in_webserver = Rails.const_defined?(:Server) || begin
    self_caller = caller
    self_caller.grep(%r{config.ru}).any? || # EXAMPLE: config.ru:3:in `block in <main>' OR config.ru:3:in `new_from_string'
      self_caller.grep(%r{puma/request}).any? || # EXAMPLE: puma-5.6.4/lib/puma/request.rb:76:in `handle_request'
      self_caller.grep(%{/rack/handler/}).any? || # EXAMPLE: iodine-0.7.44/lib/rack/handler/iodine.rb:13:in `start'
      (Concurrent.on_jruby? && self_caller.grep(%r{jruby/rack/rails_booter}).any?) # EXAMPLE: uri:classloader:/jruby/rack/rails_booter.rb:83:in `load_environment'
  end || false
end
```

### In a Rack middleware

This is the simplest answer: if you only want code to run in the webserver, invoking it on the first (or any) request makes sense to me. In Ruby on Rails, I think the development environment's "are there pending migrations?" check is a neat example because Rails does the check in the request, and then raises a [special kind of `ActionableError`](https://github.com/rails/rails/blob/b83739f81cc9f0f8028d98e1a3d7f6f79c375fb5/activerecord/lib/active_record/migration.rb#L147-L156) that causes the "Run pending migrations" button to appear.

**Aside:** I think people are sometimes too quick to reach for Rack middleware instead of doing a Controller `before_action`; consider that too.

### Other thoughts

There is a lot of trickiness to this problem. Mastodon is sorta special because it’s an *application that is distributed*. As opposed to your own specially customized Rails application you’re wholly developing, or a narrow gem/engine that you’re distributing to be installed in someone else’s application.

It’s tough to recommend a single best option. For a gem or engine, like Solid Queue or GoodJob, you’re probably focused most on the simplest and trouble-free installation with the widest compatibility. For your own application, the goal is probably not leaving a forgotten footgun to be stumbled over in the future. Good luck!
