---
title: "TIL: Detecting block returns in Ruby"
date: 2021-10-11 12:01 PDT
published: true
tags:
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "7604197bf20b470b"
  vector: "8//9Bwf9/QEEAQcM/P///Q0BA/oCBgUK/vH3/gj7AgP6Av0KAP36BPoD+wQA+wAC+/IAC//7A/cG9vwE/fz3+wME/P8FBAUC+w4GA/7/8/j0/f4ADAD+BBECAv/5Cvn+Avn/AwEF//UG+Aj+/vv/AgP/A/wD/wgHEw0EAAMJ/AAD//wD9QX8/AkCAP//+f///gX7CwP7AvoDCPz9Agb7Af8AAwQC/f3z+f/4/QHv9Qz+AgQOBwL5+gcK/gEG/Pn18fwDAQMH/wz0AwH4APgH9gX8+Ab8Cwn89/329wn/AwAF+QgHAPUFAf4AA/r/Bg7+/PgOBfcI+gP6CPwB/vP9Awb+/Qr//AUHDwIJ+vcDAQUBBgL+/QD/+fz9/Ar2AgL+//j+9wn9Cwr6AAEN/Pn4CPn7BAED/QAC+wL9/PsL+QD89gwEAQYF+fryAwAI/wb4A/z1+PoCAvn3BPgPBfALAwQK/hABCQgAAP73Avz9/fj++vX9+QYDAAT0AAMF+f0O"
---

I was doing some research on introspecting Ruby on Rails database transactions for a [Reddit thread](https://www.reddit.com/r/ruby/comments/q54515/comment/hg9dzdc/?utm_source=reddit&utm_medium=web2x&context=3), and came across this [Rails PR](https://github.com/rails/rails/pull/29333) that had some new Ruby behavior for me: detecting an early `return` from a block.

Some background: A Ruby language feature, that can frequently surprise people, is that using `return` within a Ruby block will return not only from the block itself, but also from the block's caller too. Using `next` is really the only truly safe way to interrupt a block early; even `break` can be troublesome if the block is called by an enumerator. Also, `next` can take a return value too, just like `return` e.g. `next my_value`.  

I found the Rails PR interesting, because it has a method for detecting and warning on an early return. Here's a simplified example:

```ruby
def some_method(&block)
  block.call
  completed = true # won't be called if the block returns early
ensure
  if completed
    puts "ok"
  else
    puts "returned early"
  end
end

some_method { return } # => "returned early"
some_method { next } # => "ok"
````

This works because the methods `ensure` block will always be called, even if `#some_method` returns early. That was a novel implementation for me.
