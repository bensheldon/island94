---
title: "Writing Object Shape friendly code in Ruby"
date: 2023-10-01 08:05 PDT
published: true
tags: [Ruby]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "0407d29beb4d1ba0"
  vector: "APz8CfoA/vr5/AIHBgEKAw8B9f8K/P8N+/wCAAPyAQL9CP8IAP4A+/8C+gEBC/4A+uwA/ff+AAIK/f/9/P8K+vz3AAYDCQYJ/AMBBQX+9vvq//79BfkD+/8KAgUMAAX/BvT/Bf4HEgYF+//2Af8IAf4F+v3//wgHDgcIA/4B9QD8AfQF+QX9BAkC9QX8Agr8+w72CAD99f7+BQL4+gEGBAEIBfYGAQHyBv0DAvz6/xH8/QQACAP7+f78//wFBP8E9fwAAQUC/wvu+P/yCP3++/0L+/zwAwz++An5+QP/BAAB/AYJBPz9+Pjw8AAB+QgC9/QFAfMD/fz6BPT+BwP+//8C7f//+wcCEQD2CwEDBAIE/wD9+Pz6APr9/wL9/gII9vsE9Qj7BQr/+/8GAAD8AfcD/wn8/wUM+gb8CP4K+wAA/wYOAf0EB/8G+wn8BAED/P74B//8/f/7+QEHDP4JCAQL/v74DQEEAv75AP/++/f/C/YG/An4BA32BgX5+PwB"
---

**Update:** Jean Boussier wrote a [deeper explaination of how Ruby Object Shapes are implemented](https://railsatscale.com/2023-10-24-memoization-pattern-and-object-shapes/) (and more up-to-date for Ruby 3.3, unreleased as of October 23, 2023) and when and how to optimize for them.

> My rule of thumb is that one or two memoized variables in a class are fine, but more than that likely deserve a quick refactor.

My original post is below...

Ruby 3.2 includes a performance optimization called Object Shapes, that changes how the Ruby VM stores, looks up, and caches instances variables (the variables that look like `@ivar`) . YJIT also takes advantage of Object Shapes, and the upcoming Ruby 3.3 has further improvements that improve the performance of Object Shapes.

This is a brief blog post about how to write your own Ruby application code that is optimized for Object Shapes. If instead you'd like to learn more about how Object Shapes is implemented in Ruby, watch [Aaron Patterson's RubyConf 2022 video](https://www.youtube.com/watch?v=R0oxlyVUpDw) or read this [explanation from Ayush Poddar](https://poddarayush.com/posts/object-shapes-improve-ruby-code-performance/) .

*Big thank you to my colleagues John Hawthorn and Matthew Draper for feedback on the coding strategies described here. And John Bachir, Nate Matykiewicz, Josh Nichols, and Jean Boussier whose conversation in [Rails Performance Slack](https://www.speedshop.co/rails-performance-workshop.html) inspired it.*

### The general rule: define your instance variables in the same order every time

To take advantage of Object Shape optimizations in your own Ruby Code, the goal is to minimize the number of different shapes of objects that are created and minimize the number of object shape transitions that occur while your application is running:

- Ensure that instances of the same class share the same object shape
- Ensure that objects do not frequently or unnecessarily transition or change their shape
- Help objects that _could_ share the same object shape (e.g. substitutable child classes) to do so, with reasonable effort and without compromising readability and maintainability.

This succinct explanation is from [Ayush Poddar](https://poddarayush.com/posts/object-shapes-improve-ruby-code-performance/), and explains the conditions that allow objects to share a shape:

> New objects with the same [instance variable] transitions will end up with the same shape. This is independent of the class of the object. This also includes the child classes since they, too, can re-use the shape transitions of the parent class. But, **two objects can share the same shape only if the order in which their instance variables are set is the same.**

That's it, that's what you have to do: if you want to ensure that two objects share the same shape, make sure they define their instance variables in the same order. Let's start with a counterexample:

```ruby
# Bad: Object Shape unfriendly
class GroceryStore
  def fruit
    @fruit = "apple"
  end

  def vegetable
    @vegetable = "broccoli"
  end
end

# The "Application"
alpha_store = GroceryStore.new
alpha_store.fruit # defines @fruit first
alpha_store.vegetable # defines @vegetable second

beta_store = GroceryStore.new
beta_store.vegetable # defines @vegetable first
beta_store.fruit # defines #fruit second
```

In this example, `alpha_store` and `beta_store` do not share the same object shape because the order in which their instance variables are defined depends on the order the application calls their methods. This code is not Object Shape friendly.

### Pattern: Define your instance variables in initialize

The simplest way to ensure instance variables are defined in the same order every time is to define the instance variables in `#initialize`:

```ruby
# Good: Object Shape friendly
class GroceryStore
  def initialize
    @fruit = "apple"
    @vegetable = nil # declare but assign later
  end

  def fruit
    @fruit
  end

  def vegetable
    @vegetable ||=  "broccoli"
  end
end
```

~~It's also ok to define instance variables implicitly with `attr_*` methods in the class body, which has the same outcome of always defining the instance variables in the same order.~~ **Update**: Ufuk Kayserilioglu informed me that `attr_*` do not define the instance variable until they are first called, meaning that these methods or their associated instance variables should also be declared with a value in `#initialize`.

Now I realize this is a very simplistic example, but that's really all there is to it. If it makes you feel better, at GitHub where I work, we have classes with upwards of 200 instance variables. In hot code, where we have profiled, we go to a negligible effort of making sure those instance variables are defined in the same order; it's really not that bad!

### Pattern: Null memoization

Using instance variables to memoize values in your code may present a challenge when nil is a valid memoized value. This is a common pattern in Ruby that is not Object Shape friendly:

```ruby
# Bad: Object Shape unfriendly
class GroceryStore
  def fruit
    return @fruit if defined?(@fruit)
    @fruit = an_expensive_operation
  end
end
```

Rewrite this by creating a unique `NULL` constant and check for its presence instead:

```ruby
# Good: Object Shape friendly
class GroceryStore
  NULL = Object.new
  NULL.freeze # not strictly necessary, but makes it Ractor-safe

  def initialize
    @fruit = NULL
  end

  def fruit
    return @fruit unless @fruit == NULL
    @fruit = an_expensive_operation
  end
end
```

Alternatively, if you're doing a lot of meta or variable programming and you need an arbitrary number of memoized values, use a hash and key check instead:

```ruby
# Good: Object Shape friendly
class GroceryStore
  def initialize
    @produce = {}
  end

  def produce(type)
    return @produce[type] if @produce.key?(type)
    @produce[type] = an_expensive_operation(type)
  end
end
```

### That's it

Creating Object Shape friendly code is not very complicated!

Please reach out if there's other patterns I'm missing: bensheldon@gmail.com / [twitter.com/@bensheldon](https://twitter.com/bensheldon) / [ruby.social/@bensheldon](https://ruby.social/@bensheldon)
