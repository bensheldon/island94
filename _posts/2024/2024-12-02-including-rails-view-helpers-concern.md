---
title: "Including Rails View Helpers is a concern"
date: 2024-12-02 09:01 PDT
published: true
tags: ["rails"]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "e1cd833297fb84ce"
  vector: "8vX3BQYGAwj6/QYAAQkCBw/99wn/BAAK8/gA9gP8BgX3//oGBgb59PoI9v/69gv1A/YEBP/4A/wB+QAH/gv+/voA/AgF/voEA/sA/v/8+vEBCAQFBgX8/AoCBPwI/v/4Av/8BPj5Cf4H/v8GAAH9AvcACfQK/gcEBAgQBxAC9AACB/gK/gj/BwoGBQgB/gYC+QX4+/j+/gUBBQb/AP4E/gL+CQQFA/j19QD3/QP7Aw79/vwADAP28/8BB/UA8vkB/vwD/QH+8gkEBv7v+vwEBAD8AAX4AQQE/v3++gD/AgAH+QP5Cfv+AQj29QEF/wH/8/4C/vIIAPkGA/kEBQUD/gXu7Qf3B/39CQIDBPwH+vn6Avr2/f8BAw3+/v0EAv8C9fkC+w78Bfz9/QYFBvkD+vn0CP/8/AUJ/ff7BQQI+AAFBgH//QT9CP4JAgD4/Af3AQbwAPsF//8DBPUFBf0NBwAKAg34AAQE//sCAwT//u8AAvUC9gsACQn1Bf38//sI"
---

If you’re currently maintaining a Ruby on Rails codebase, I want you to do a quick regex code search in your Editor:

```
include .*Helper
```

Did you get any hits? Do any of those constants point back to your `app/helpers` directory? That could be a problem.

**Never include a module from `app/helpers` into anything in your application.** Don’t do it.

- Modules defined in `app/helpers` should exclusively be View Helpers. Every module in the `app/helpers` directory is automatically included into Views/Partials, and available within Controllers via the `helpers` proxy e.g. `helpers.the_method` in Controllers or `ApplicationController.helpers.the_method` anywhere else.
- Including View Helpers into other files (Controllers, Models, etc.) creates a risk that some methods may _not_ be safely callable because they depend on View Context that isn’t present. (They’re also hell to type with Sorbet.)
- If you do have includable mixins (“bucket of methods”) that do make sense to be included into lots of different classes (Controllers, Models, Views, etc.), make them a concern and don’t put them in `app/helpers`.

## Some general background

Rails has always had View Helpers. Prior to Rails 2 (~2009), only the `ApplicationHelper` was included into all controller views and other helpers would have to be added manually. Rails 2 changed the defaults via `helpers :all` and `config.action_controller.include_all_helpers` to always include _all_ Helpers in _all_ Views.

Rails 4.0 (2012) [introduced Concerns](https://signalvnoise.com/posts/3372-put-chubby-models-on-a-diet-with-concerns), which formalized conventions around extracting shared behaviors into module mix-ins.

Rails 5.0 (2016) introduced the Action Controller [`helpers` proxy](https://github.com/rails/rails/pull/24866), and clearly summarizes the problem that I’ve observed too:

<blockquote markdown=1>

It is a common pattern in the Rails community that when people want to use any kind of helper that is defined inside app/helpers they includes the helper module inside the controller like:

```ruby
module UserHelper
  def my_user_helper
    # ...
  end
end

class UsersController < ApplicationController
  include UserHelper

  def index
    render inline: my_user_helper
  end
end
```

This has problem because the helper can't access anything that is
defined in the view level context class.

Also all public methods of the helper become available in the controller
what can lead to undesirable methods being routed and behaving as
actions.

Also if you helper depends on other helpers or even Action View helpers
you need to include each one of these dependencies in your controller
otherwise your helper is not going to work.

</blockquote>

## Some specific background

This has come up as a problem at my day job, GitHub. GitHub has the unique experience of being one of the oldest and largest Ruby on Rails monoliths and it’s full of opportunities to identify friction, waste, and toil.

Disordered usage of View Helpers and the `app/views` directory became very visible as we’ve been typing our monolith with Sorbet. Typing module mixins in Sorbet is itself [inherently difficult](https://sorbet.org/docs/requires-ancestor), but View Helpers had accumlated a significant amount of `T.unsafe` escape-hatches and in understanding why… we discovered that explicitly including View Helpers in lots of different types of classes was a cause.

## What’s the alternative?

I analyzed the different types of modules that were being created, and came up with this list:

- **Concerns** are shared behaviors that may be optionally included into multiple other classes/objects when that behavior is desired. We can further break down:
  - **Application-level Concerns** are agnostic about the kind of object they are included into (could be a controller, or model, or a job, or a PORO)
  - **Component-level Concerns** are intended to only be mixed into a specific kind of object, like a controller with expectations that controller-methods are available to be used in that concern (like an http request object, or other view helpers like path helpers)
- **Dependencies** are non-shared behaviors that have been extracted into a module from a specific, singular controller to improve behavioral cohesion, and is then included back into that one, specific class or object.
- **View Helpers** are intended to be across Views (or Controllers via the `helpers` view-proxy method in Controllers or `ApplicationController.helpers` anywhere else) for formatting and presentation purposes and have access to other view helpers or http request objects. These are the only objects that modules that should go in `app/helpers`.

And this is what you might do about them:

- **Stop and remove `include MyHelper` from Controllers.** Instead, you can access any View Helper method in a controller via `helpers.the_name_of_the_method`
- **Move Concerns and Dependencies out of `app/helpers`.** If what is currently in `app/helpers` is not a View Helper, move it:
  * Application-level Concerns should be moved into `app/concerns`
  * Component-level Concerns should be moved into their appropriate `app/controllers/concerns` or `your_package/models/concerns`, etc.
  * Dependencies should be moved to an appropriate place in their namespaces hierarchy. e.g. if the module is only included into `ApplicationController`, it should be named `ApplicationController::TheBehavior` and live in `app/controllers/application_controller/the_behavior.rb`
- **Never include a module from `app/helpers` anywhere.** Don’t do it.
- **Use the Controller `helpers` proxy or `ApplicationController.helpers.the_helper_method`** to access helpers (like `ActionView::Helpers::DateHelper`) in Controller or other Object contexts.
- **Invert the relationship between Helpers and Concerns.** If you have behavior that you want available to lots of different kinds of components _and_ views, start by creating a Concern, and then include that Concern _into_ a View Helper or `ApplicationHelper`. Don’t go the other direction.
- **Invert the relationship between Views and Controllers.** If you have a private method that is specific to a single controller, and you want to expose that method to the controller’s views, you can expose that method to the views directly using `helper_method :the_method_name` . Use this sparingly, because it extends singleton View objects which deoptimizes the Ruby VM; but really, don’t twist yourself into knots to avoid it either, that’s what it’s there for.
- **(optional but recommended) Rename the constant too, not just move it, when it’s not a View Helper.** Naming things is hard, but `*Helper` is… not very descriptive. While it’s the placement in `app/helpers` that brings the automatic behavior… so it’s not _technically_ a problem to have a `SomethingHelper` that isn’t a View Helper living in `app/controllers/concerns` … it is confusing to have non-helpers named `SomethingHelper`. Some suggestions for renaming Concerns and Dependencies:
  - Use the “-able” suffix to turn the behavior or capability into an adjective. e.g. `SoftDeletable`
  - Append `Dependancy` to the end, like `AbilityDependency`
  - If you’re out of ideas, use `Methods` or `Mixin`, like `UserMethods` or `UserMixin`.
