---
title: "Bad requests and the dream of a quiet Rails app"
date: 2026-10-28 15:00 UTC
published: true
tags: [Ruby on Rails, Ruby]
---
I've kept a notebook page since, oh, 2013, of common exceptions I've encountered ever since I started building production Rails applications. It's a big one.

When you put a web application on the internet, it's going to get hit with a firehose of garbage requests: scanners and bots that are trying to discover malicious vulnerabilities, and scanners and bots trying to do something useful, like put your website in a search engine, but are built oddly.

And when you're using an exception monitoring product like Sentry or AppSignal or whatever, as you should, you're going to start being alerted to exceptions from this natural background noise of the firehose of garbage.

A non-exhaustive list of garbage you might see when you put your application on the internet:

- Fetching of paths like `/.env` and `/wp-admin/login.php`.
- Trying different HTTP methods/verbs (GET, POST, etc.) or making up verbs.
- Weird mimetypes.
- Weird headers. Fun fact: HTTP headers can contain binary bytes, like the User-Agent string. And if something in your application (like a logger) is expecting clean UTF-8, you're gonna be alerted.
- Weird POST bodies.
- Weird, weird stuff. Invalid encodings, lengths too long; if it can go in a packet, it will arrive at your website. Your problem now.

In your exception monitoring service, one of those garbage requests might look like:

```
ActionController::BadRequest: Invalid path parameters: Invalid encoding for parameter: � (Rack::QueryParser::InvalidParameterError)
```

Or:

```
ActionDispatch::Http::MimeNegotiation::InvalidType: "*.*" is not a valid MIME type (Mime::Type::InvalidMimeType)
```

Or, because of the recent [PHP2Shell](https://en.wikipedia.org/wiki/PHP2Shell) vulnerability last week, I started getting some new scans that triggered:

```
Rack::Multipart::BoundaryTooLongError: multiple boundary parameters found in multipart content type (Rack::Multipart::BoundaryTooLongError)
```

Fun stuff!

And, my assumption here is that this _is_ garbage, and not a potential business partner using Internet Explorer for Mac or your boss's friend checking it out on their Blackberry (true stories!) that you can't _simply_ throw away.

And, the reason why I have this all written down in my notebook is the core questions:

- Did this result in my application returning a **500 error**? e.g. "it broke". Which can become an ambiguous compliance problem of like "what was the nature of the breakage and is that bad?"
- Did this result in my application returning a **400 error**? e.g. "lol no". And secondarily, why did I get alerted to this if the application already handled it?

And that implies the long-term goal of having the notebook is:

- Handling 500 errors ("it broke") so they become 400 errors ("lol no").
- Not getting alerted on those exceptions because they're not exceptional; it's the internet being the internet.

That's the dream of a quiet Rails app.

### Why you see exceptions

Most Ruby apps use Rack, which is a standardized interface for connecting a webserver (like Puma) to a web application (like Rails). A request comes in at the top, to the webserver, and then passes through a bunch of middleware that processes the request, and then hands it to the web application.

The game here is understanding at which stage the processing of the request would raise a particular exception, and then looking at what exception handling or reporting equipment it will pass through.

This is a simplified middleware stack of a typical Rails app, with examples of how Sentry instruments it by inserting its own middleware and hooks. (Sentry is nothing special here; other monitoring products patch similarly, but also differently, which is part of the fun of figuring this out):

1. **Puma**: _any exception raised to Puma is a 500 error_
   - `Sentry::Puma#lowlevel_error` **← Sentry hook #3**
2. `ActionDispatch::HostAuthorization` / `Sendfile` / `Static` / `Executor` / `LocalCache` / `Rack::Runtime` / `Rack::MethodOverride` / `ActionDispatch::RequestId` / `ActionDispatch::RemoteIp`
3. `Rails::Rack::Logger`
4. `ActionDispatch::ShowExceptions`: _turns exceptions into 400/404/500 pages_
5. `Sentry::Rails::CaptureExceptions` **← Sentry hook #2**
6. `ActionDispatch::DebugExceptions`
7. `Sentry::Rails::RescuedExceptionInterceptor` **← Sentry hook #1**
8. Callbacks / Cookies / Session / Flash / CSP / Head / ConditionalGet / ETag / TempfileReaper
9. Rails Routes and Controller rendering

The main takeaway here is that any exception that is raised earlier/higher in the request than `ActionDispatch::ShowExceptions` will likely turn into a 500 response, and you'll see there is a big list of things above it and immediately below Puma.

Any exception that is raised later/lower than `ActionDispatch::ShowExceptions` will likely turn into a 400 response. But it may still be reported to your exception monitor if it's not part of an ignore list. Here is [Sentry's default exception ignore list](https://github.com/getsentry/sentry-ruby/blob/811815676597c4fd408d2cfa01b577b1011f2be8/sentry-rails/lib/sentry/rails/configuration.rb#L49-L64), for example.

What's annoying is that all these exceptions are a complete grab-bag. Which is why you need a notebook to keep track of them. And you will likely end up with your own custom middleware called something like `MalformedRequestHandler` that you'll stick at the top of the stack and customize, and write little notes as it changes like:

> I think [this problem] that the MalformedRequestHandler addresses has been fixed upstream within Rails: [rails/rails#40124](https://github.com/rails/rails/pull/40124) which triggers an `ActionController::BadRequest` when accessing params/payload through `ActionDispatch::Request`. In 2015, Rack introduced a more targeted `Rack::QueryParser::InvalidParameterError < ArgumentError`: [rack/rack#820](https://github.com/rack/rack/pull/820/files#diff-69c5b6856deb050ba393562673e0cc863d520360df07503081064f531e852bc2R13)

These things are _always_ changing! While investigating the `BoundaryTooLongError` exception, I saw that unreleased Rack carries [an improvement](https://github.com/rack/rack/pull/2505) that will address it, and that there is [an unmerged PR](https://github.com/rails/rails/pull/58677) in Rails that would also improve things.

Fortunately too, with LLMs it's a lot easier now to take an exception and be like "help me understand what raised this, what HTTP error code it produced, why it was reported to my error monitor, write a regression test for it, help me make sure it turns into a 400 and isn't reported, and find me any upstream Issues or PRs that reference that. Thanks buddy!"

That's the work!
