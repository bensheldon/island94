---
title: "Wide Models and Active Record custom validation contexts"
date: 2025-04-01 08:00 PDT
published: true
tags: [Rails]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "c8b3276abfc83aaf"
  vector: "9fv5BAEA/QIBAP/+CgEEAgcE9QIE+f8K7/n+AQH2CAH/AQX9Awr+9/r0AAYA/wP8+/v//AQE/AEC9/UCAAH4BPsF8/4DAgAE8gIA/f/8/v38DAD6BwL++wD+Bv8KBAABA/0DCf4EAwAR/f0AAvwIAv8BDAH7AfsA/gEI/QP59wAGD/0L+Af5AwME/QsCAg4E9AsEBQL1/AoAAwEJ+AP5/AYHCwcC+Ab4AgT9BfkFAQj+AAoDAf70AgAACQAH+PUF/P7/8wf9+wXx/gHrBQH3CPwE7wn9+QUA8f77AAf/AwAH8/0ECfcIB/fx/P0GAf748vkHBwUI9wj5A+7+AAL+Af4A7/3+AAcJAgf4/wIF+v34/P/7+QIDAgf7BAH9DAEMAgQI+wD//fv7Bf/7+/j+/vL4DAf8AgUA/Ab9BAL88AD3BwkG/fkK+wcBBgD1AAoI/gT0CgcK+wEO+vYLBP8OAQcLAAf9+/8CAAH//QcH+Pb8A/YD+g37AQQABfYGAgUF"
---

This post is a brief description of a pattern I use a lot using when building features in Ruby on Rails apps and that I think needed a name:

**Wide Models** have many attributes (columns in the database) that are updated in multiple places in the application, but not always all at once i.e. different forms will update different subsets of attributes on the same model.

*How is that not a [“fat model”](https://codeclimate.com/blog/7-ways-to-decompose-fat-activerecord-models)?*

> As you add more intrinsic complexity (read: features!) to your application, the goal is to spread it across a coordinated set of small, encapsulated objects (and, at a higher level, modules) just as you might spread cake batter across the bottom of a pan. Fat models are like the big clumps you get when you first pour the batter in. Refactor to break them down and spread out the logic evenly. Repeat this process and you'll end up with a set of simple objects with well defined interfaces working together in a veritable symphony.

I dunno. I've seen teams take Wide Models pretty far (80+ attributes in a model) while still maintaining cohesion and developer productivity. And I've seen the opposite where there is a profusion of tiny service objects and any functional change must be threaded not just through a model, view and controller but also a form object and a decorator and several command objects, or where there is large number of narrow models that all have to be joined or included nearly all of the time in the app—and it sucks to work with. I mean, find the right size for you and your team, but the main thrust here is that bigger doesn't inherently mean worse.

This all came to mind while reading Paweł Świątkowski's [“On validations and the nature of commands”](https://katafrakt.me/2025/02/05/validations-nature-commands/):

> Recently I took part in a discussion about where to put validations. What jarred me was how some people inadvertently try to get all the validation in a one fell swoop, even though the things they validate are clearly not one family of problems.

The post goes on to suggest differentiating between:

- “input validation”, which I take to mean user-facing validation that is only necessary when the user is editing some fields concretely on a form in the app. Example: that an account's email address is appropriately constructed.
- “domain checks”, which I take to mean as more fundamental invariants/constraints of the system. Example: that an account is uniquely identified by its email address.

I didn't entirely agree with this advice though:

> In Rails world you could use `dry-validation` for input validations and ActiveRecord validation for domain checks. Another approach would be to heavily use form objects (input validation) and limit model validations to actual business invariants.

My disagreement is because Active Record validations have a built-in feature to selectively apply validations: [Validation Contexts \(the `on:` keyword\)](https://guides.rubyonrails.org/active_record_validations.html#on) and specifically [_custom_ validation contexts](https://guides.rubyonrails.org/active_record_validations.html#custom-contexts):

> You can define your own custom validation contexts for callbacks, which is useful when you want to perform validations based on specific scenarios or group certain callbacks together and run them in a specific context. A common scenario for custom contexts is when you have a multi-step form and want to perform validations per step.

I use custom validation contexts _a lot_. I don't intend for this to be a tutorial on custom validation contexts, but just to give a quick example:

- Imagine you have an `Account` model
- A person can register for an account with just an email address so they can sign in with a magic link.
- An account holder can later add a password to their account if they want to optionally sign in with a password
- An account holder can later add a username to their account which will be displayed next to their posts and comments.

You might set up the `Account` model validations like this:

```ruby
class Account < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  # also set up uniqueness/not-null constraints in the database too
  validates :email, email_structure: true, on: [:signup_form, :update_email_form]

  validates :password, password_complexity: true, allow_blank: true
  validates :password, presence: true, password_complexity: true, on: [:add_password_form, :edit_password_form]

  validates :username, uniqueness: true, allow_blank: true
  validates :username, presence: true, on: [:add_username_form, :edit_username_form]
end
```

Note: it's possible to add _custom_ validation contexts on `before_validation` and `after_validation` callbacks, but not others like `before_save`, `after_commit`, etc. only take the non-custom callbacks like `on: :create`.

So to wrap it up: sure, maybe it can all go in the Active Record model.
