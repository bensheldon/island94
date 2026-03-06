---
title: "A bulletproof `wait_for_turbo` test helper"
date: 2026-03-06 00:18 UTC
published: true
tags: []
---

I like Hotwired Turbo like I liked UJS (Unobtrusive Javascript): it adds a few small but helpful tricks to my application's toolbox. One problem though with adding any javascript is that because the webpage is more dynamic, writing full-browser system tests becomes harder because we need to make sure the webpage is in *just the right state* to interact with it in tests. It’s annoying to write tests super defensively to avoid flakey tests.

### Enumerating states Turbo can be in

Turbo adds some attributes to the webpage DOM that we can look for in our tests to ensure that things are in the right state. But it’s tricky. Let’s start with the trickiest thing first.

Turbo sets `aria-busy`  when navigation is happening:

- Turbo Drive sets `html[aria-busy]` when navigating
- Turbo Frames set `turbo-frame[aria-busy]` when navigating
- Turbo forms set `form[aria-busy]` when submitting

…but when doing a very typical Submit-a-Form-and-Redirect operation, Turbo drops the `[aria-busy]` for a brief moment after the form submit returns a redirect response but before navigating to the redirected page sets the `[aria-busy]` again. That sucks. 

The other things we need to be aware of and wait for are more pedestrian:

- The first time a page is loaded and Turbo hasn’t been loaded at all yet. This probably wouldn’t matter because, of course, we’re all using progressive enhancement so nothing is functionally inaccessible when javascript isn’t loaded. But our tests should be deterministic. And we have the non-browser Rack Test driver to cover the non-javascript scenario (which are super fast too). To handle this scenario, we’ll add an attribute to our server-rendered HTML layout, and then remove it after Turbo has loaded.
- Turbo Previews. Which is like a weird cached version of the page Turbo will show, but might get yanked away when the _actual_ response finishes and Turbo swaps them. Fortunately turbo adds a `data-turbo-preview` attribute we can test for.

### Doing the simplest thing about it

Let’s start with the test helper, and then we’ll wire up the pieces:

```ruby
def wait_for_turbo
  return unless Capybara.current_driver != :rack_test

  page.assert_no_selector "html[aria-busy], form[aria-busy], turbo-frame[aria-busy], html[data-turbo-not-loaded], html[data-turbo-loading], html[data-turbo-preview]", visible: :all
end
```

Not bad! It simply waits, because `assert_no_selector` uses Capybara's async timeout, until the page doesn't have any of the "I'm loading" attributes on it. Easy.

To handle the `turbo-not-loaded` attribute, add something like this to your layout(s):

```ruby
<!-- app/views/layouts/application.html.erb -->
<html data-turbo-not-loaded="1">
```

And then in your javascript, at the very bottom after you’ve loaded Turbo and everything else:

```javascript
// app/javascript/application.js

import "@hotwired/turbo-rails"
// ...

document.addEventListener("turbo:load", function() {
  document.documentElement.removeAttribute("data-turbo-not-loaded")
  document.documentElement.removeAttribute("data-turbo-loading")
})

document.addEventListener("turbo:submit-start", function() {
  if (!event.target.closest("turbo-frame") {
    document.documentElement.setAttribute("data-turbo-loading", "1")
  }
})
document.addEventListener("turbo:submit-end", function(event) {
   if (!event.detail.fetchResponse?.redirected) {
    document.documentElement.removeAttribute("data-turbo-loading")
  }
})
```

The carve-out logic for setting `data-turbo-loading` on `turbo:submit-start` and removing it on `turbo:submit-end` is a bit complicated:

- We don't want to set `data-turbo-loading` on Turbo Frames because Turbo Frames don’t emit `turbo:load` events so the attribute would never be removed. More importantly and fortunately, Turbo Frames don’t suffer from an `aria-busy` gap. 
- And we don’t want to remove `data-turbo-loading` if it’s a redirect, to bridge the `aria-busy` gap mentioned earlier. We'll wait for the subsequent `turbo:load` to clean it up.

There it is. Now you just need to put `wait_for_turbo` before any action that could potentially engage Turbo e.g.

```ruby
# ...
click_on "Do something"
wait_for_turbo
click_on "The result"
#...
```

### I hate it

Yeah, that’s awful. We want our system tests to invoke declarative behavior, not be littered with “wait for it….”. So… we’re going to patch Capybara. Here we go…:

```ruby
module SystemTurboClick
  def click(...)
    unless session.driver.is_a?(Capybara::RackTest::Driver)
      assert_no_ancestor("[aria-busy], html[data-turbo-not-loaded], html[data-turbo-loading], html[data-turbo-preview]", visible: :all)
    end
    super
  end
end

Capybara::Node::Element.prepend SystemTurboClick
```

Now anytime that Capybara does a click event, it will first wait for Turbo to do its thing.
