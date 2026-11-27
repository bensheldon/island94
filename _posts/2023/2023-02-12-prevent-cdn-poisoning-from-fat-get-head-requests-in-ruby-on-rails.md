---
title: "Prevent CDN poisoning from Fat GET/HEAD Requests in Ruby on Rails"
date: 2023-02-12 12:32 PST
published: true
tags: [rails]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "d4c74bf8892254fa"
  vector: "+gQAA/33AwIBA/wFAP8D/Qz2+gUJDAcG8fXz9Af6DgH0AAUEAvH+/wIE/AICAQf//fsA/QP89/P3AgEF+/sI+f77+QIHCQX/6/sJB/z19/n9+gICAwP+AAn4Bfv9CvwDBwD7CQX8CAAGAQUOBf78AP8A+QIH+fn7Cvv9/QT4AAACCgMB/QIJAQUG+/4CAPkB+QELAgcA/vv6AP8D+f8EAgb/BQEMCPP9AwH5BPn2/AYE/f0FFQcAAvv/AvoN9vr5/QIKCwf9AQP+AP7y+AkGCA39+Qn8BQb3+wEF+//9/gAD8/gPB/sJ/wX7/AD//fwC+v0BAfQG9AD3B/wDAP8ABfr79//8Ff0BCAEECAsC+foACQf/+wMF/vQI/v8HBPT/AfoB9Qn6/PkHAQ0A+f4ABvb7AggEC/AN9QAG+/4K/AAGBPsE9wkHAfv/AwL+//r9+wD07fUCA/4JBP4I//cC/P7/AQP7AgIDBAQE/v8EAQUF/AL48wv9+gT+BAMR9/kG"
---

There are many different flavors of [web cache poisoning discovered by Security Researcher James Kettle](https://portswigger.net/research/web-cache-entanglement). Read on for an explanation of one I've run across…

**What is a Fat GET/HEAD Request?** A GET or HEAD request is "fat" when it has a request body. It's unexpected! Typically one sees a request body with a POST or PUT request because the body contains form data. The HTTP specification says that including a request body with GET or HEAD requests is [_undefined_](https://stackoverflow.com/a/983458). You can do it, and it's up to the application to figure out what that means. Sometimes it's bad!

You can get a sense of the applications that intentionally support Fat Requests (and how grumpy it makes some people) by reading through this [Postman issue](https://github.com/postmanlabs/postman-app-support/issues/131).

**Fat Requests can lead to CDN and cache poisoning in Rails.** CDNs and caching web proxies (like Varnish) are frequently configured to cache the response from a GET or HEAD request based solely on the request's URL and not the contents of the request body (they don't cache POSTs or PUTs at all). If an application isn't deliberately handling the request body, it may cause unexpected content to be cached and served.

For example, you have a `/search` endpoint:

- `GET /search` shows a landing page with some explanatory content
- `GET /search?q=foo` shows the search results for "foo".
- Here's what a Fat Request looks like:

  ```text
  GET /search     <== the url for the landing page

  q=verybadstuff  <== oh, but with a request body
  ```

In a Rails Controller, `parameters` (alias `params`) merges query parameters (that's the URL values) with request parameters (that's the body values) into a single data structure. If your controller uses the presence of `params[:q]` to determine whether to show the landing page or the search results, it's possible that when someone sends that Fat Request, your CDN may cache and subsequently serve the results for `verybadstuff` every time someone visits the `/search` landing page. That's bad!

Here's how to Curl it:

```bash
curl -XGET -H "Content-Type: application/x-www-form-urlencoded" -d "q=verybadstuff" http://localhost:3000/search
```

 Here are 3 ways to fix it…

## Solution #1: Fix at the CDN

The most straightforward place to fix this should be at the caching layer, but it's not always easy.

With Cloudflare, you could rewrite the GET request's `Content-Type` header if it is `application/x-www-form-urlencoded` or `multipart/form-data`. Or use a Cloudflare Worker to drop the request body.

Varnish makes it easy to drop the request body for any GET request.

Other CDNs or proxies may be easier or more difficult. It depends!

Update via [Mr0grog](https://github.com/Mr0grog): AWS Cloudfront returns a [403 by default](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/RequestAndResponseBehaviorCustomOrigin.html#RequestCustom-get-body).

## Solution #2: Deliberately use `query_parameters`

Rails provides three different methods for accessing parameters:

- `query_parameters` for the values in the request URL
- `request_parameters` ) for the values in the request body
- `parameters` (alias `params`) for the problematic combination of them both. Values in `query_parameters` take precedence over values in `request_parameters` when they are merged together.

Developers could be diligent and make sure to only use `query_parameters` in `#index` or `#show` , or `get` routed actions. Here's an example from the [`git-scm` project](https://github.com/git/git-scm.com/issues/1551).

## Solution #3: Patch Rails

Changes were [proposed in Rails](https://github.com/rails/rails/issues/39974) to not have `parameters` merge in the body values for GET and HEAD requests; it was rejected because it's more a problem with the upstream cache than it is with Rails.

You can patch your own version of Rails. Here's an example that patches the method in [`ActionDispatch::Request`](https://github.com/rails/rails/blob/21a3b52ba0b7d94b4903e02b6ac537a7d1d1c817/actionpack/lib/action_dispatch/http/parameters.rb#L49-L63):

```ruby
# config/initializers/sanitize_fat_requests.rb
module SanitizeFatRequests
  def parameters
    params = get_header("action_dispatch.request.parameters")
    return params if params

    if get? || head?
      params = query_parameters.dup
      params.merge!(path_parameters)
      set_header("action_dispatch.request.parameters", params)
      params
    else
      super
    end
  end
  alias :params :parameters
end

ActionDispatch::Request.include(SanitizeFatRequests)

# Some RSpec tests to verify this
require 'rails_helper'

RSpec.describe SanitizeFatRequests, type: :request do
  it 'does not merge body params in GET requests' do
    get "/search", headers: {'CONTENT_TYPE' => 'application/x-www-form-urlencoded'}, env: {'rack.input': StringIO.new('q=verybadstuff') }

    # verify that the request is correctly shaped because
    # the test helpers don't expect this kind of request
    expect(request.request_parameters).to eq("q" => "verybadstuff")
    expect(request.parameters).to eq({"action"=>"panlexicon", "controller"=>"search"})

    # the behavioral expectation
    expect(response.body).not_to include "verybadstuff"
  end
end
```
