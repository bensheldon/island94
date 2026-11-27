---
title: "Rails 103 Early Hints could be better, maybe doesn’t matter"
date: 2025-10-17 15:00 UTC
published: true
tags: [ruby on rails]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "74ce142ad93c976d"
  vector: "9AMEBAj++gAGAAIH/PEI/wn9AvwF/AMDAv3/AwX4B//2A/4N/vn8CQUE/An/+wEF+vsC//31/fn3/QQIBPUD9wUBA/kFBgEA7/v6AP4A8/P69AMEAQIDAAr6APb6B/cQ//n0BwYBCf0FAAIXAPv7BQL7/vsK+QcHEQkE+gT5+wAHBfoB9f0E+/sFA/77/vX/BAQJBPz4APsFBf8D+P8L///6B/sF/P/8AgL4+wD/8wgCAwEOCgD++/4CAgAL+/T59f0FCQYH+gkIAAPz+wERAAn8/wD7+wr2+QH/BgP6+gAM9/4OAwAGAwX/CwD6/gQIAP0K/vgA+wj//gP/9Pn+BQQD/Ab4CwMKE/z+APYE/wP9BQn6BAED9/v8/AgDAfz9A/f4+Af+Af//+wj/AvoB/PEA9wAIBvMM/AP4AwEG+wD8A/77BRADBfv8DAsDAQL/+/z5+PkPAvgDAwER/QAB9/v7AAv9AggKAPv6/f79/fb58ff3+QgAAgP8/gUMAAAH"
---

I recently went on a brief deep dive into 103 Early Hints because I looked at a [Shakapacker PR](https://github.com/shakacode/shakapacker/pull/722) for adding 103 Early Hints support. Here’s what I learned.

Briefly, [103 Early Hints](https://developer.chrome.com/docs/web-platform/early-hints) is a status code for an HTTP response that happens _before_ a regular HTTP response with content like HTML. The frontrunning response hints to the browser what additional assets (javascript, css) the browser will have to load when it renders the subsequent HTTP response with all the content. The idea being that the browser _could_ load those resources while waiting for the full content response to be transmitted, and thus load and render the complete page with all its assets faster overall.

If you look at a response that includes 103 Early Hints, it looks like 2 responses:

```text
HTTP/2 103
link: </application.css>; as=style; rel=preload,</application.js>; as=script; rel=modulepreload

HTTP/2 200
date: Fri, 17 Oct 2025 15:07:24 GMT
content-type: text/html; charset=utf-8
link: </application.css>; as=style; rel=preload,</application.js>; as=script; rel=modulepreload

<html>
... the content
```

I keep writing “103 Early Hints” because Early Hints the status code response (103), also gets confused with the `Link` header of a content response that serves the same purpose (hinting what assets will need to be loaded), and near identical content: the 103 Early Hint header is usually same the `Link` value that the actual-content response header has. Because of this conceptual collision, it’s tough to google for and there are various confused StackOverflow responses.

Eileen Uchitelle built out [the original implementation in Rails](https://eileencodes.com/posts/http2-early-hints/). It’s good. It can be better. It also maybe doesn’t matter. I’ll tell you how and why.

### It can be better

There’s two ways that the Rails implementation of 103 Early Hints can be better:

1. There should only be one 103 Early Hints response.
2. The 103 Early Hints response should be emitted in a `before_action` instead of near the tail-end of the response.

**There should only be one 103 Early Hint response.** According to [the RFC](https://datatracker.ietf.org/doc/html/rfc8297), there can be multiple 103 responses, but according to the Browsers, they only look at the first 103 response.

> A server might send multiple 103 responses, for example, following a redirect. **Browsers only process the first early hints response**, and this response must be discarded if the request results in a cross-origin redirect. — [MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/103)

> **Chrome ignores the second and following Early Hints responses. Chrome only handles the first Early Hints response** so that Chrome doesn’t apply inconsistent security policies (e.g. Content-Security-Policy). — [Chromium Docs](https://source.chromium.org/chromium/chromium/src/+/main:docs/early-hints.md;l=18?q=early%20hints&ss=chromium%2Fchromium%2Fsrc:docs%2F)

Rails emits a 103 Early Hint response each and every time your application calls `javascript_include_tag`, `stylesheet_link_tag`, or `preload_link_tag`.

Instead, it would be better if the application could accumulate multiple asset links and then flush them to a single 103 Early Hint response all together.

Aside: it’s really, really, cool how 103 Early Hint responses in Rack/Puma/Rails are emitted _in the middle of a handling a response_. The webserver puts a lambda/callable into the Rack Environment, and then the application calls that lambda with the contents of the 103 Early Hint response, and that causes the webserver to write the content to the socket. [Here’s how it’s done in Puma](https://github.com/puma/puma/blob/a5206f1acdb953f87e690909d4434bb7e0b134af/lib/puma/request.rb#L78-L87), in pseudocode:

```ruby
# In the Puma webserver
request.env["rack.early_hints"] = lambda do |early_hints_str|
  fast_write_str socket, "HTTP/1.1 103 Early Hints\r\n#{early_hints_str}\r\n"
end

# In the application
request.env["rack.early_hints"]&.call("link: </application.css>; as=style; rel=preload,</application.js>; as=script; rel=modulepreload")
```

**The 103 Early Hint response should be emitted in a `before_action` instead of near the tail-end of the response.** As mentioned, the 103 Early Hint response gets triggered when using `javascript_include_tag`, `stylesheet_link_tag`, or `preload_link_tag`. Those usually are used in a Rails Layout `erb` file.

In Rails, Layouts get rendered last, after the view is rendered, which means that 103 Early Hints get emitted when the response is almost done being constructed: after the controller action, after the databae queries, after most of the HTML has been rendered to a string.

Instead, it would be better if the 103 Early Hint response was emitted in a `before_action` before any slow database queries or view rendering happens. The purpose of the 103 Early Hint is to be _early_. I've done this myself, manually constructing the links and flushing them through `request.send_early_hints`, it's not difficult, but it would be nice if it was easier.

### It maybe doesn’t matter

I can’t actually get 103 Early Hints to be returned all the way to me in any of my production environments. Likely because there is a network device, reverse proxy, load balancer, CDN, or something that’s blocking them.

- 👎 Heroku with Router 2.0 and custom domain
- 👎 Heroku behind Cloudfront
- 👎 Digital Ocean App Platform behind Cloudflare
- 👎 AWS ECS+Fargate behind an ALB (this one actually breaks the website: `HTTP/2 stream 1 was not closed cleanly`)

I can see them working locally, using Puma or Puma behind Thruster, but in production…. nada. Obviously this isn’t comprehensive list of production environments, but they’re the ones _I_ am using.

If you want to see them locally:

```bash

# Run Puma with early hints. Or use `early_hints` DSL directive in puma.rb
$ bin/rails s --early-hints

# Make a request, this works locally or against a production target
$ curl -s -k -v --http2 localhost:3000 2>&1 | grep -A 5 -E '103 Early Hints|HTTP/2 103'

< HTTP/1.1 103 Early Hints
< link: </assets/application-316caf93b23ca4756d151eaa97d8122c7173f8bdfea91203603e56621193c19e.css>; rel=preload; as=style; nopush
<
< HTTP/1.1 103 Early Hints
< link: </vite-dev/assets/application-WvRi4PrU.js>; rel=modulepreload; as=script; crossorigin=anonymous; nopush
<
< HTTP/1.1 103 Early Hints
< Link: </vite-dev/assets/index-ilXdZXkf.js>; rel=modulepreload; as=script; crossorigin=anonymous
<
```

And if you want to see 103 Early Hints… anywhere… good luck! I have yet to find an example of a website that serves them.

```bash
# Basecamp
$ curl -s -k -v --http2 https://basecamp.com 2>&1 | grep -A 5 -E '103 Early Hints|HTTP/2 103'
# nothing

# GitHub
$ curl -s -k -v --http2 https://github.com 2>&1 | grep -A 5 -E '103 Early Hints|HTTP/2 103'
# nothing

# Shopify
$ curl -s -k -v --http2 https://www.shopify.com 2>&1 | grep -A 5 -E '103 Early Hints|HTTP/2 103'
# nothing

# Google
$ curl -s -k -v --http2 https://www.google.com 2>&1 | grep -A 5 -E '103 Early Hints|HTTP/2 103'
# nothing

# Someone's tester for 103 Early Hints
$ curl -s -k -v --http2 https://code103.hotmann.de 2>&1 | grep -A 5 -E '103 Early Hints|HTTP/2 103'
< HTTP/2 103
< link: </app.min.css>; as=style; rel=preload
<
# ... ok, that returns something
```
