---
title: "Living Parklife with Rails, coming from Jekyll"
date: 2025-01-05 16:12 PST
published: true
tags: [meta, jekyll, rails]
redirect_from:
  - /2025/1/living-parklife-with-rails-coming-from-jekyll
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "7bc0b2de5256a518"
  vector: "/f0BBQz9/QT+BvUQAgIDAwMK+/4AAQYF/vn8Afz7AgD4/gcMCPL8AgQH+v3//AX2/f7/9v32/gD7+wD6Bf78/AH/+AkKAfgF9f7/9QMF+/EE+wMFAPcDAwsEBP8R//cAAf4ACgIEC/kDAgUVAP8EAAX8AwAA/AgGDwkGAwYG+AAGDPYI+wb7+PkEBgr+AP329gQDBfwA+fwF/gIG+P8E/vz//gAE9gH29/71Av4FBQQE+QACCArv/Pj6DggIAPsGAAEJCgMFAAEF/v7z/P/4BQL69AMJ+AjzAP8B/wT7AgAM9/8J//sBAAD1+P///v36/vkC/vIH9AgFCfoF+/0EAvrw/AvzCAL/DwD+Av8J+QUAA/z5+/UE/fsB7Ar8BgP+/vEH/gD+/wcF/QcDCAX5+wAEAgACCO0L/f8A+gIN+wAADv/9/AgHBfsECf76CfkFAgD1AvsDAQQC+/4CBPcHBPwHA/r4CQEC/vsG/fP39PsC+/r9/wwLAgAIBAQI9v0A"
---

I recently migrated this blog from Jekyll to [Ben Pickles’s Parklife](https://parklife.dev/) and Ruby on Rails, still hosted as a static website on GitHub Pages. I’m pretty happy with the experience.

I’m writing this not because I feel any sense of advocacy (do what you want!) but to write down the reasons for myself. Maybe they’ll rhyme for you.

Here’s this blog’s repo if you want to see: [https://github.com/bensheldon/island94.org](https://github.com/bensheldon/island94.org)

### Background

I’ve been blogging here for 20 years and this blog has been through it all: Drupal, Wordpress, Middleman, Jekyll, and now Parklife+Rails.

For the past decade the blog has largely been in markdown files, which I don’t intend to change. Over the past 2 years I also exported 15 years of pinboard/del.icio.us bookmarks, and my Kindle book highlights into markdown-managed files too. I’ve also dialed in some [GitHub Action and Apple Shortcut powered integrations](https://island94.org/2024/1/trigger-github-actions-workflows-from-apple-shortcuts). I’m really happy with Markdown files in a git repo, scripted with Ruby.

…but there’s more than _just_ Ruby.

### Mastery

I’m heavily invested in the Ruby on Rails ecosystem. I think it’s fair to say I have mastery in Rails: I’m comfortable building applications with it, navigating and extending the framework code, intuiting the conceptual vision of the core team, and being involved in the life of the comunity where I’ve earned some positive social capital to spend as needed.

I don’t have that in Jekyll. I am definitely handy in Jekyll. I’ve built plugins, I’ve done some wild stuff with liquid. But I’m not involved with Jekyll in the everyday sense like I am with Rails. I *feel* that when I go to make changes to my blog. There’s a little bit of friction mentally switching over to liquid, and Jekyll’s particular utilities that are *similar to but not the same* as Action View and Active Support. Jekyll is great; it’s me and the complexity of my website that’s changed.

(I do still maintain some other Jekyll websites; no complaints elsewhere.)

### Parklife with Ruby on Rails

I hope I’m not diminishing [Parklife](https://parklife.dev/) by writing that it isn’t functionally _much_ more than `wget`. It’s in Ruby and mounts+crawls a Rack-based web application, does a little bit to rewrite the base URLs, and spits out a directory of static HTML files. That’s it! It’s great!

It was pretty easy for me to make a lightweight Ruby on Rails app, that loaded up all my markdown-formatted content and frontmatter, and spat them out again as Controllers and ERB Views.

This blog is about 7k pages. For a complete website artifact:

- Jekyll: takes about 20 seconds to build
- Parklife with Rails: takes about 20 seconds to build

In addition to the productivity win for me of being able to work with the ERB and Action View helpers I’m familiar with, I also find my development loop with Parklife and Rails is _faster_ than Jekyll: I don’t have to rebuild the entire application to see the result of a single code or template change. I use the Rails development server to develop, not involving Parklife at all. On my M1 MBP a cold boot of Rails takes less than a second, a code reload is less than 100ms, and most pages render in under 10ms.

With Jekyll, even with `--incremental`, most development changes required a 10+ second rebuild. Not my favorite.

### The technically novel bits

1. if you want to trigger Rails code reload with any arbitrary set of files, like a directory of markdown files, you use `ActiveSupport::FileUpdateChecker` (which has a kind of complicated set of arguments):

   ```ruby
   # config/application.rb
   self.reloaders << ActiveSupport::FileUpdateChecker.new([], {
     "_posts" => ["md", "markdown"],
     "_bookmarks" => ["md", "markdown"],
   }) do
     Rails.application.reload_routes!
   end
   ```

2. Each of my blog posts has a list of historical redirects stored in their frontmatter (a legacy of so many framework changes). I had to think about how to do a catch-all route to render a static meta-refresh template:

   ```ruby
   # config/routes.rb
   Rails.application.routes.draw do
     get "*path", to: "redirects#show", constraints: ->(req) { Redirect.all.key? req.path.sub(%r{\A/}, "").sub(%r{/\z}, "") }
     # ...all the other routes
   end
   ```

### In conclusion

Here’s [this blog’s Parkfile](https://web.archive.org/web/20250131105413/https://github.com/bensheldon/island94.org/blob/main/Parkfile). I did a little bit of convenience monkeypatching of things I intend to contribute upstream to Parklife. I dunno, maybe you’ll like the Parklife too.
