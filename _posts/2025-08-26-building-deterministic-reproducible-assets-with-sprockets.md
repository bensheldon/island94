---
title: "Building deterministic, reproducible assets with Sprockets"
date: 2025-08-26 03:03 UTC
published: true
tags: [Ruby on Rails, Ruby]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "7c40bb95effd975d"
  vector: "8gn+Awvz/v8DAgAQAf77/AQA+wL//wYECv72/Qf6Bgj7/wYSBvv6/wkJ+gT5AQz88AAA/fv7/f77Bv8A+gP0/wkADPwI/gcD8wP8CQEE9fMA8wb5APkICQj7AwIJBfwEBQoBBwEDBAQJ+gAP9gYCBAb9/wT2Af4HDgUH/vj9/QAF/v0G+AD7/AUIAgT9CAAA+wEPAwD++PkCAQb/9f4H//4DBwAA+fj9CPr0//v6Av3+/wgLCAj1/wbvCv4M/gABAAMJCgYE//4J/vz1AwT5/QT9+QT4+gj8/f8G/P34/wAG8wAJAfkEAgD6+/35+QEEAOwA+fkD/wgJBfP8APwBBvbx+wP7EAAAAwr8BQcD/foDAwkGAvgQ/vkA/wQJ//b2+PwB8wEIAf/8+/4FBwD9+f0G+gQEAPADCPwA/PcN/QD8CfkIAAIGBQn2Dvf4BPsA//v3+P4I/wH7AQMKAQAFAQH5/wT8AgUA/PgCAvf29//6AwQC9QkM+goBCP0A8v3+"
---

This is a story that begins with airplane wifi, and ends with the recognition that everything is related in web development.

While on slow airplane wifi, I was syncing this blog's git repo, and it was taking forever. That was surprising because this blog is mostly text, which I expected shouldn't require many bits to transfer for Git. Looking more deeply into it (I had a 4-hour flight), I discovered that the vast majority of the bits were in the git branch of built assets that gets deployed to GitHub Pages (`gh-pages`) when I build my Rails app into a static site [with Parklife](https://island94.org/2025/01/living-parklife-with-rails-coming-from-jekyll). And the bits in that branch were assets (css, javascript, and a few icons and fonts) built by Sprockets, whose contents were changing every time the blog was built and published. What changed?

- Sprockets creates a file manifest that is randomly named `".sprockets-manifest-#{SecureRandom.hex(16)}.json"`.
- Within the file manifest, there is an entry for every file built by Sprockets, that includes that original asset's `mtime`—when the file on the filesystem was last touched, even if the contents didn't change.
- By default, Sprockets generates gzipped `.gz` copies of compressible assets, and it includes the uncompressed file's `mtime` in the gzipped file's header, producing different binary content even though the compressed payloads' contents didn't change.

Do I need that? Let's go through it.

### The Sprockets Manifest

The Sprockets Manifest is pretty cool (I mean `public/assets/.sprockets-manifest-*.json`, not `app/assets/config/manifest.js` which is different). The manifest is how Sprockets is able to add unique cache-breaking digests to each file while still remembering what the file was originally named. When building assets on a server with a persisted filesystem, Sprockets also uses the manifest to keep _old_ versions of files around: `bin/rails assets:clean` will keep the last 3 versions of built assets, which is helpful for blue-green deployments. Heroku also has a [bunch of custom stuff](https://devcenter.heroku.com/articles/rails-4-asset-pipeline#multiple-versions) powered by this too to make deployments seamless.

But none of that is applicable to me and this blog, which gets built from scratch and committed to Git. Or for that matter, when I build some of my other Rails apps with Docker; not unnecessarily busting my cached file layers would be nice 💅

The following is a monkeypatch, which works with Sprockets _right now_ but I'm hoping to ultimately propose as a configuration option upstream (as others [have proposed](https://github.com/rails/sprockets/issues/707)).

```ruby
# config/initializers/sprockets.rb
module SprocketsManifestExt
  def generate_manifest_path
    # Always generate the same filename
    ".sprockets-manifest-#{'0' * 32}.json"
  end

  def save
    # Use the epoch as the mtime for everything
    zero_time = Time.at(0).utc
    @data["files"].each do |(_path, asset)|
      asset["mtime"] = zero_time
    end

    super
  end

  Sprockets::Manifest.prepend self
end
```

Now, if you're like me (on a plane), you might be curious about why the obsessive tracking of `mtime`. I have worked alongside several people in my career with content-addressable storage obsessions. The idea being: focus on the contents, not the container. And `mtime` is very much a concern of the _container_. But Sprockets [makes the case](https://github.com/rails/sprockets/blob/58759051635c3d660421908702b6ade729dd4ab8/README.md#cache) that "Compiling assets is slow" so I can see it's useful to quickly check when the file was modified, in a lot of cases… but not mine.

Let's move on.

### GZip, but maybe you don't need it

So… everything in web development is connected. While wondering why new copies of every `.gz` file were being committed on every build, I remembered what my buddy Rob recently did in Rails: [`MakeActiveSupport::Gzip.compress`deterministic](https://github.com/rails/rails/pull/55382).

> I have some tests of code that uses `ActiveSupport::Gzip.compress` that have been flaky for a long time, and recently discovered this is because the output of that method includes the timestamp of when it was compressed. If two calls with the same input happen during different seconds, then you get different output (so, in my flaky tests, they fail to compare correctly).

GZip takes a parameter called `mtime`, which is stored and changes the timestamp of the compressed file(s) _when they are uncompressed_. It changes the _content_ of the gzipped file, because it stores the timestamp in the contents of the file, but doesn't affect the mtime of the gzipped file _container_.

So in the case of Sprockets, if the modification date of the uncompressed asset changes, regardless of whether its contents have changed, a new and different (according to git or Docker) gzipped file will be generated. This was _really_ bloating up my git repo.

Props to Rack maintainer Richard Schneeman who [dug further down this hole previously](https://github.com/rails/sprockets/pull/197#issuecomment-162954641), admirably asking the zlib group themselves for advice. The commentary made a mention of nginx docs, which I assume is for [`ngx_http_gzip_static_module`](https://nginx.org/en/docs/http/ngx_http_gzip_static_module.html) which says:

> The files can be compressed using the gzip command, or any other compatible one. It is recommended that the modification date and time of the original and compressed files be the same.

But that's not `GZip#mtime` value stored inside the contents of the gzip file, that's the mtime of the `.gz` file container. Sprockets _also_ sets that, with [`File.utime`](https://github.com/rails/sprockets/blob/4dff018b9271c37b09889e829f8926d1c5379731/lib/sprockets/utils/gzip.rb#L19C11-L19C22).

It's easy enough to patch the mtime to the “unknown” value of `0`:

```ruby
# config/initializers/sprockets.rb
module SprocketsGzipExt
  def compress(file, _target)
    archiver.call(file, source, 0)
    nil
  end

  Sprockets::Utils::Gzip.prepend self
end
```

…though if you're in my shoes, you might not even need these gzipped assets. afaict only Nginx makes use of them with the non-default `ngx_http_gzip_static_module` module; Apache requires some complicated RewriteRules; Puma doesn't serve them, CDNs don't request them. Maybe turn them off? 🤷

```ruby
# config/initializers/sprockets.rb
Rails.application.configure do
  config.assets.gzip = false
end
```

Fun fact: [that configuration was undocumented](https://github.com/rails/sprockets-rails/pull/551)

### Maybe please don't even pass `mtime` to gzip for web assets

All of this stuff about file modification dates reminded me of _another_ thing I had once previously rabbit-holed on, which was [poorly behaved conditional requests in RSS Readers](https://github.com/feedbin/feedbin/issues/726). The bad behavior involved inappropriately caching web requests whose Last-Modified HTTP header changed, but their contents didn't. And how do webservers generate their Last-Modified header value? That's right, file `mtime`, the one that can be set by `File.utime`!

…but not the one set by `GZip#mtime=`. I cannot find any evidence anywhere that value, _in the contents of the gzip file_ matters. Nada. All it does is make the gzip file's _contents_ be different, because of that one tiny value being included. I can't imagine anything cares about the original mtime when it's unzipped, that wasn't already transmitted via the Last-Modified HTTP header. What am I missing?

Of the evidence I have, it seems like developers set `GZip#mtime=`… because it's an option? I couldn't find a reason [in the Sprockets history](https://github.com/rack/rack/commit/d2d51ff05966b36c40dc9439437e82d0a23f2b88). I noticed that Rack::Deflater does the same for reasons I haven't figured out [in their history](https://github.com/rack/rack/commit/d2d51ff05966b36c40dc9439437e82d0a23f2b88) either. This behavior probably is not busting _a lot_ of content-based caches unnecessarily, but it probably does some. So maybe don't do it unless you need to.
