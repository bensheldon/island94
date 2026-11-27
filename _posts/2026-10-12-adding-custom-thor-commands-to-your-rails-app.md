---
title: "Adding custom Thor commands to your Rails app"
date: 2026-10-12 19:06 UTC
published: true
tags: [Ruby on Rails, Ruby]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "e91f3da129851f92"
  vector: "9PsABAMD+wH/CP8EAwAJCQ76/Aj/DQEH8fH++AH2DgcD/QAJBf37AggE/QL5+wb9/QAE+/33//sB/QQEAQn/+wD8//0DAgAB//n6+gcB+vTw+wEGAQME8w8DBfMCAgMDCAX3AwAAAgAFBfsA+/0M/QT+DAIO+wMGAQkOCAAC/gAF/fkK+gL9+wX//woAB//8+QAEAwD/+P8DBQv+BQADBwUHAAEABfb3CgT1+wb5/AP++QIHDAP79/r7C/cK/AARBPQFBAUG/AD+/wf1/wD6Bvr5+voI/Af3/vYD/voBAwAN+wYJA/cE9vXx+AH6/wX6//wCB/cD+gMF/Pn++/z+Dvv36gf4BwT8EP75AvcDAvv9AQX+AAYF/fUG/AQDBgTs9PwCAAcC/AsFAQQGAvX0/PX8/QP/AvwI/gEEAfcB+AACA/j9AAgC/vwA/gT5CP8A+gH9+vQG/wv7Avj1BPkLBf0EBQUA/gr//wcB+vP59Pr0AfsH/QYECwbv/AQE7///"
---
Thor is a really nice command-line runner, with much nicer support for arguments than Rake imo. The Rails framework supports both, but [since](https://github.com/rails/rails/pull/22457) [Rails 5.1](https://github.com/rails/rails/pull/26414) most Rails' built-in commands (like `bin/rails generate`) use Thor, and it's very simple to add custom Thor-based commands to gems and engines too, which Rails will auto-discover when placed in the engine's `lib/commands` directory.

The one place Thor commands don't work out of the box is your Rails application. Rails ships with a `lib/tasks` directory, but not a `lib/commands` directory. But when you create that directory, and add your custom command to it, it still won't work.

There's a simple fix to make `lib/commands` work and have Rails auto-discover your app's custom Thor commands: add your app's `lib` directory to the Ruby load path in your app's `config/boot.rb`:

```ruby
# config/boot.rb
# ...
$LOAD_PATH << File.expand_path("../lib", __dir__) # Discover Rails commands in lib/commands.
```

And then you can simply add some custom Thor commands like so:

```ruby
# lib/commands/foobar_command.rb
class FoobarCommand < Rails::Command::Base
  desc "foobar", "Prints foobar"
  def perform(*)
    boot_application! # optional, like a Rake task's => :environment dependency
    say "foobar"
  end
end
```

## Why?! Patching `boot.rb` sucks

It is unfortunate! Here's why it's necessary for this:

When you invoke a command like `bin/rails foobar`, Rails will attempt to find a matching `commands/foobar_command.rb` within Ruby's `$LOAD_PATH`. If that file exists in the load path, the file is loaded and the command invoked. If not, you'll see `Unrecognized command "foobar" (Rails::Command::UnrecognizedCommandError)`.

But, Rails does this command lookup before fully loading your Rails application (because that's slow, I presume). And [by recent convention](https://github.com/rails/rails/pull/48596), Rails does not add `lib` to the Ruby `$LOAD_PATH` until your application has been loaded. Bit of a problem, in this context. And that's why the patch adds `lib` to the load path.

## There's got to be a better way

I made a [PR to upstream Rails](https://github.com/rails/rails/pull/50218) to try to make `lib/commands` work out of the box. It's neat because the change I proposed first does the fast-path to resolve the command without loading the application, and then if it hasn't found the command, it loads the application (adding `lib` to the load path) and tries to look up the command again.

There's also another funny/interesting thing I discovered while digging into this: Rails only loads the _first_ matching command. So if you have the `aaaaaaa` gem and it has a `lib/rails/commands/generate/generate_command.rb` earlier in Ruby's `$LOAD_PATH` than Rails' own matching file, then Rails will never load its built-in generate command. Bit of a problem! This seems like an artifact of pre-Ruby 1.9 that didn't [store the expanded canonical path of loaded features](https://github.com/ruby/ruby/blob/92135776ce7dd134916fd4931b6004322c41a9b0/NEWS#L360) (e.g. `require "feature"`). I have a [PR to change that](https://github.com/rails/rails/pull/58376) too.