---
title: "Replacing Devise with Rails `has_secure_password` and friends"
date: 2024-01-27 07:43 PST
published: true
tags: [rails, ruby]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "2d10a0c911ef881f"
  vector: "9P32BAP9DwYAAP4EBwMEBQQL+wIG/AEJ+vQK/Pj6BwL4/QT8BAEB9P3+9Aj6BQIF/fwJ/gMA8gEC/AEBAAED//oB+vwO+/z79PkE/gT99v35/gT+B/4C/Qb+CQQB/AQA+QH2Dv8FA/kMAgkBAwYIBQIHCQb8BwEKCQoHAv/8/AD6DfQH8ggA/wMC+wsFAPz+/AEOAwL+A/4B/f8B/QD6/wMGBAEM/P709wX///T6AQ0E//gCAAD09P3/BPYM+vr8/vsBAgUB9Af8A/H0Bg4DCggA8RD2/wT68f8D/ggFBQAE9gICDfwNAvbw+P0CAQb5+gcAA/MT8/kBAPwD+AIHBgAA8f79BP0BDwT9/QEIAv77CAP6/fb9+QX5Avj6CAoF/foCBgIEAfgIAAr9+/n++Pb7+wUCAf0FAgEA+PgD9wAGBwgLAwQB/Pb/AAMC+v0E+//4+/cG+wEDBvoHBvsKAAQD+Qj1//0A9wIG/vX7+gACA/YA/REH/gX7A/0H+PX6"
---

I love the [Devise user-authentication gem](https://github.com/heartcombo/devise). I've used it for years, and I recently moved off of it in one of my personal apps and replaced it with Rails's built-in `has_secure_password` and `generates_secure_token` and a whole bunch of custom controllers and helpers and code that I now maintain myself. **I do not recommend this! User authentication is hard! Security is hard!**

**And...** maybe you need to walk the same path too. So I want to share what I learned through the process.

Ok, so to back up, why did I do this?
- Greater compatibility with Rails `main`. My [day job runs Rails `main`](https://github.blog/2023-04-06-building-github-with-ruby-and-rails/), and I'm more frequently contributing to Rails development; I'd like to run my personal projects on Rails `main` too. When I looked back on upgrade-blocking gems, Devise (and its dependencies, like Responders) topped my list.
- More creative onboarding flows. I've twisted Devise quite a bit (it's great!) to handle the different ways I want users to be able to register (elaborate onboarding flows, email-only subscriptions, optional passwords, magic logins). I've already customized or overloaded nearly every Devise controller and many model methods, so it didn't seem like such a big change anyway.
- Hubris. I've built enterprise auth systems from scratch, managed the Bug Bounty program, and worked with security researchers. I have seen and caused and fixed some shit. (Fun fact: I have been paid for reporting auth vulnerabilities on the bug bounty platforms themselves.) I know that even if it's not a bad idea _for me_, it's not a great idea either. Go read [all of the Devise-related CVEs](https://github.com/advisories?query=devise+ecosystem%3Arubygems); seriously, it's a responsibility.

That last bit is why this blog post will not be like, "Here's everything you need to know and do to ditch Devise." Don't do it! Instead, here's some stuff I learned that I want to remember for the next app I work on.

### A test regime

I went back through all of my system tests for auth, and here is a cleaned-up, though not exhaustive list of my scenarios and assertions. It seems like a lot. It is! There are also unit tests for models and controllers and mailers and separate API tests for the iOS and Android apps. Don't take this lightly! (Remember, many of these are specific to my custom onboarding flows).

- When a new user signs up for an account
  - Their email is valid, present and stored; password is nil.
  - They are not confirmed
  - They receive a confirmation email
  - If not confirmed, registering again with the same email resends the confirmation email but does not leak account presence
  - If the email associated account already exists and is confirmed, sends a "you already have an account" email and does not leak account presence.
  - Following the link in the confirmation email confirms the new account and redirects to the account setup page.
- When a user sets up their account
  - They can assign a username and password
  - A password cannot be assigned if a password already exists
  - A username cannot be assigned if a username already exists
  - If a username and password already exist, the setup page redirects to the account update page
  - The account update page redirects to the setup page if a username or password does not yet exist
  - Signing in with an unsetup account redirects to setup page
  - Resetting password with an unsetup account redirects to setup page
  - Adding a password invalidates reset-password links.
- When a user updates their account
  - The current password is required to update email, username, or password.
  - When the email address is changed, a new confirmation email is sent out to that email address.
  - An email change confirmation can be confirmed with or without an active session.
  - If the email address is already confirmed by a different account, send the "you already have an account" email and do not leak account presence.
  - Multiple accounts can have the same unconfirmed email address.
- When a user performs a password reset
  - Can't be accessed with an active session
  - Link is invalidated after 20 minutes, or when email, or password changes.
  - Can be performed on an unsetup account
  - Confirms an email but not an email change
  - Signs in the user
  - Does not leak account presence
  - Is throttled to only send once a minute.
- When a user performs or resends an email confirmation
  - Can be accessed with an active session.
  - Cannot resend confirmation of an email change without an active session.
  - Link is invalidated after 20 minutes, or when email, unconfirmed email, confirmed at, or password changes.
  - Signs in the user
  - Does not leak account presence
  - Is throttled to only send once a minute.
  - When user is already confirmed, send them an email with a link to reset their password
- When a user signs into a session
  - Requires a valid email or username, and password
  - Cannot sign in with a nil, blank, or absent password param (unsetup account)
  - Session is invalidated when email or password changes.
  - Does not leak account presence with missing or invalid credentials
  - Redirects to the `session[:return_to]` path if present, otherwise the root path.

### Using `has_secure_password`

This was a fairly simple change. I had to explicitly add `bcrypt` to the gemfile, and then add to my `User` model:

```ruby
# models/user.rb
alias_attribute :password_digest, :encrypted_password
has_secure_password :password
```

I'll eventually rename the database column, but this was a zero-migration change.

Also, you might need to use `validations: false` on `has_secure_password` and implement your own validations if you have custom onboarding flows like me. Read [the docs](https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html) and the [Rails code](https://github.com/rails/rails/blob/68eade83c87ae309191add6dfa4959d7d7e07464/activemodel/lib/active_model/secure_password.rb#L114).

When authenticating on sign in, you'll want to use `User.authenticate_by(email:, password:)`, which is intended to avoid timing attacks.

### Using `generates_token_for`

The `generates_token_for` methods are new in Rails 7.1 and [really nice](https://github.com/rails/rails/pull/44189). They create a signed token containing the user id and additional matching attributes and it doesn't need to be stored in the database:

```ruby
# models/user.rb
generates_token_for :email_confirmation, expires_in: 30.minutes do
  [confirmed_at, email, unconfirmed_email, password_salt]
end

generates_token_for :password_reset, expires_in: 30.minutes do
  [email, password_salt]
end
```

I'll explain that `password_salt` in a bit.

To verify this, you want to do use something like this: `User.find_by_token_for(:email_confirmation, value_from_the_link)`.

btw security: when you put a link in an email message, you can only use a `GET` , because emails can't reliably submit web forms (some clients can, but it's weird and unreliable). So your link is going to look like `https://example.com/account/reset_password?token=blahblahblahblahblah`. If there is any links to 3rd party resources like script tags or off-domain images, you will [leak the token through the `referrer`](https://portswigger.net/kb/issues/00500400_cross-domain-referer-leakage) when the page is loaded with the `?token=` in the URL. [Devise never fixed it (😱)](https://github.com/heartcombo/devise/pull/4366) . What you should do is take value out of the query param and put it in the session and redirect back to the same page without the query parameter and use the session value instead. (Fun fact: this is a bug bounty that got me paid.)

### Authenticatable salts

Here's where I explain that `password_salt` value.

There's several places I've mentioned where tokens and sessions should be invalidated when the account password changes. When `bcrypt` stores the password digest in the database, it also generates and includes a random "salt" value that changes every time the password changes. Comparing that salt is a proxy for "did the password change?" and it's safer to embed that random salt in cookies and tokens instead of the user's hashed password.

[Devise uses the first 29 characters](https://github.com/heartcombo/devise/blob/e2242a95f3bb2e68ec0e9a064238ff7af6429545/lib/devise/models/database_authenticatable.rb#L15C6-L158C1) of the encrypted password (which is technically the [algorithm, cost and salt](https://en.wikipedia.org/wiki/Bcrypt#Description)):

```ruby
# models/user.rb
def authenticatable_salt
  encrypted_password[0, 29] if encrypted_password
end
```

But it's also possible to simply get the salt. I dunno if the difference matters (tell me!):

```ruby
# models/user.rb
def password_salt
  BCrypt::Password.new(password_digest).salt[-10..] if password_digest
end
```

### A nice session

There's a lot to write about creating sessions and remember-me cookies, that I won't be writing here. The main thing to note is that I'm storing and verifying both the user id _and_ their password salt in the session; that means all of their session are invalidated when they change their password:

```ruby
# app/controllers/application_controller.rb
UNASSIGNED = Module.new
USER_SESSION_KEY = "_yoursite_user".freeze

def initialize
  super
  @_current_user = UNASSIGNED
end

def sign_in(user)
  session[USER_SESSION_KEY] = [user.id, user.password_salt]
end

def current_user
  return @_current_user unless @_current_user == UNASSIGNED

  # Check if the user was already loaded by route helpers
  @_current_user = if request.env.key?("current_user")
                     request.env["current_user"]
                   else
                     user_id, password_salt = session[USER_SESSION_KEY]
                     User.find_by_id_and_password_salt(user_id, password_salt) if user_id && password_salt
                   end
end

```

In doing this project I learned that Rail's cookies will magically serialize/deserialize arrays and hashes. I've been manually and laboriously converting them into JSON strings _for years_ 🥵

btw, if that `UNASSIGNED` stuff is new to you, go read my [Writing Object Shape friendly code in Ruby](https://island94.org/2023/10/writing-object-shape-friendly-code-in-ruby).

### Rotating active sessions

This is a little _extra_ but I wanted the switchover to be transparent to users. To do so, I read from Devise's active sessions and then create a session cookie using the new format. It looks something like this:

```ruby
# controllers/application_controller.rb
before_action :upgrade_devise_session

def upgrade_devise_session
  # Devise session structure: [[USER_ID],"AUTHENTICATABLE_SALT"]
  if session["warden.user.user.key"].present?
    user_id = session["warden.user.user.key"].dig(0, 0)
    user_salt = session["warden.user.user.key"].dig(1)
  elsif cookies.signed["remember_user_token"].present?
    user_id = cookies.signed["remember_user_token"].dig(0, 0)
    user_salt = cookies.signed["remember_user_token"].dig(1)
  end
  return unless user_id.present? && user_salt.present?

  # Depending on your deploy/rollout strategy ,
  # you may want need to retain and dual-write both
  # Devise and new user session values instead of this.
  session.delete("warden.user.user.key")
  cookies.delete("remember_user_token")

  user = User.find_by(id: user_id)
  sign_in(user) if user && user.devise_authenticatable_salt == user_salt
end
```

### Route helpers

Devise mixes some nice helper methods into Rails's routing DSL like `authenticated`; they're even _necessary_ if you need to authenticate Rails Engines that can't easily access the app's ApplicationController methods. Here’s how to recreate them using [Route Constraints](https://guides.rubyonrails.org/routing.html#advanced-constraints) and monkeypatching `ActionDispatch::Routing::Mapper` (that’s [how Devise does it](https://github.com/heartcombo/devise/blob/e2242a95f3bb2e68ec0e9a064238ff7af6429545/lib/devise/rails/routes.rb#L28))

```ruby
# app/constraints/current_user_constraint.rb
class CurrentUserConstraint
  def self.matches?(request)
    new.matches?(request)
  end

  def initialize(&block)
    @block = block
  end

  def matches?(request)
    current_user = if request.env.key?("current_user")
                      request.env["current_user"]
                    else
                      user_id, password_salt = request.session[USER_SESSION_KEY]
                      request.env["current_user"] = User.find_by_id_and_password_salt(user_id, password_salt) if user_id && password_salt
                   end

    if @block
      @block.call(current_user, request)
    else
      current_user.present?
    end
  end
end


# config/routes.rb
module ActionDispatch
  module Routing
    class Mapper
      def authenticated(&)
        scope(constraints: CurrentUserConstraint, &)
      end

      def unauthenticated(&)
        scope(constraints: CurrentUserConstraint.new { |user| user.blank? }, &)
      end

      def admin_only(&)
        scope(constraints: CurrentUserConstraint.new { |user| user&.admin? }, &)
      end
    end
  end
end

Rails.application.routes.draw do
  # ...
  authenticated do
    resources :special_somethings
  end
end
```

Because routing happens _before_ a controller is initialized, the current user is put into `request.env` so that the controller won't have to query it a second time from the database. This could also be done in a custom Rack Middleware.

If you want to put stuff into not-the-session cookies, those cookies can be accessed via `request.cookie_jar,` e.g., `request.cookie_jar.permanent.encrypted["_my_cookie"]`.

### Closing thoughts

That was all the interesting bits for me. I also learned quite a bit poking around Dave Kimura’s [ActionAuth](https://github.com/kobaltz/action_auth) (thank you!), and am thankful for the many years of service I’ve gotten from Devise.
