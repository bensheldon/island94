---
title: "Hanami and loading code, faster"
date: 2025-10-08 00:00 UTC
published: true
tags: [Ruby on Rails, Hanami]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "29bbfda8276d7f0d"
  vector: "9vn+B/z9Agr0AgMH/wELBAz88wkD9/YO/vcE/gX5/gf8A/sFCfb8+Ab99wMD+wr9/fcCBwH+/vsOAQED+AEF//v+AAQN/v4AAv/+/wEA+/b+/woGAwII9AgAAvcH/v0AAvX6BvsHCgMC+QEA+AEEAAL7AQYF/gUICAUJAv4H8wD+AvQO+Pn/+/8AAg/+CQkB+AMMCwP79vYNBv4E9gIM/QACBvMAAvjzAgbz/gH7BAf68wQDCgf99QHwCQH/9fYNAwD/AAn4+f36/Pz4Af72BAYA+wf+/Af08/sD/wf8AwAO/P0ECvwB+gH2+fgBAQcH+vQDBfkI/PkE/+8D+/35AwD17wT/CwT4EwD5BfoB/f36BAL3A/4G/QQE+wUH+wQB8/kE9gP5+wEABf4H+/cD//T2+gIDAv4LB/3///oG9wAH/v0EAwMEBAEJBg//A/8GB//zAvsG+AMF/gIABPwLA/wF+wcAAgMGBQIA/f8G+fwCB/ME+QYABQUBBwn/+gX9"
---

I’ll be giving a talk in November in at SF Ruby Conference ([tickets on sale now!](https://luma.com/sfrubyconf2025?coupon=SEP29OCT6)). My talk is speeding up your application’s development cycle by taking a critical eye at your application’s development boot. Which all boils down to _do less_. In Ruby, the easiest, though not the simplest, is to load less code. So yeah, autoloading.

To expand my horizons and hopefully give a better talk, I branched out beyond my experience with Ruby on Rails to talk to Tim Riley about Hanami and how it handles code loading during development.

The following are my notes; it’s not a critical review of Hanami, and it only looks into a very narrow topic: code loading and development performance.

### Ruby, and analogously Rails

Ruby has a global namespace; constants (classes, modules, CONSTANTS) are global singletons. When your code (or some code you’re loading—Ruby calls each file it loads a “feature" identified by its filesystem path) defines a constant, Ruby is evaluating everything about the constant: the class body, class attributes, basically anything that isn’t in a block or a method definition. And so any constants that are referenced in the code also need to be loaded and evaluated, and class ancestors, and their code and so forth. That’s the main reason booting an application is slow: doing stuff just to load the code that defines all the constants so the program can run.

The name of the game in development, where you want to run a single test or browser a single route or open the CLI, is _load less_. If you can just avoid loading the constant, you can avoid loading the file the constant is defined in, and avoid loading all of its other dependencies and references until _later_, when you really need them (or never, in development).

The most common strategy for deferring stuff is: use a string as a stand-in for the constant, and only later, when you really need to convert the string to a constant, do it. An example is in Rails Routes, where you’ll write `to: “mycontroller#index”` and not `MyController`. At some point the `mycontroller` gets constantized to `MyController`, but that’s _later_, when you hit that particular route. Another example is Active Record Relation definitions, where you’ll use `class_name: “MyModel"` instead of `class_name: MyModel`, which only gets constantized when you use `record.my_models`.

In Rails, a lot of performance repair work for development is identifying places where a constant _shouldn’t_ be directly referenced and instead should use some other stand-in until it’s really needed. In Rails, it can be confusing, because sometimes you can use a configuration string to refer to a constant, and sometimes you have to use a constant; it is inconsistent.

### In Hanami, (nearly) everything has a string key

Hanami’s approach: make _all_ the application components referencable by a string, called a `key`. (again, Hanami does quite a bit more than that, I just mean in regards to code loading). Objects are configured by what keys they have dependencies upon, and those objects are [injected by the framework](https://guides.hanamirb.org/v2.2/app/container-and-components/#injecting-dependencies-via-deps). So instead of writing this:

```ruby
class MyClass
  cattr_accessor :api_client
  self.api_client = ApiClient.new # <-- loads that constants

  def transmit_something
    MyClass.api_client.transmit("something")
  end
end
```

…you would instead use Hanami’s `Deps` and write:

```ruby
class MyClass
  include Deps["api_client"] # <-- injects the object

  def transmit_something
    api_client.transmit("something")
  end
end
```

Keys are global, and keys whose objects have been loaded live in `Hanami.app.keys` . If the key’s object hasn’t been loaded yet, it will be converted from a string to… whatever (not just constants)… when it’s needed to execute. Individual objects can be accessed with `Hanami.app["thekey"]` when debugging, but normal code should get them injected from Deps. By convention, keys match a class name but they don't have to. This is [powered by `dry-system`](https://dry-rb.org/gems/dry-system/).

Not _everything_ has to have a key. Functional components in Hanami have a key, but classes that embody a bit of data (in Hanami these are called Structs) do not have entries in the app container, and therefore don't have keys.

If you have something functional coming from outside Hanami, like that `ApiClient` in the code above or coming from a non-Hanami specific gem or wherever, then you can give them a key and define their lifecycle within the application [via a Provider](https://guides.hanamirb.org/v2.2/app/providers/).

**Briefly, commentary:** Some common Rails development discourse is “Rails is too magic”, which is leveled because Rails framework can work out what constants you mean without directly referencing them (e.g. `has_many :comments` implies there’s an Active Record `Comment`), and “just use a PORO” (plain old ruby object) when a developer is trying to painfully jam _everything_ into narrow Rails framework primitives. With Hanami:
- Hanami has quite a bit of like “here’s a string, now it’s an object 🪄” , but it is consistently applied everywhere and has some nice benefits beyond just brevity, like overloading dependencies.
- Everything does sorta have to be fit into the framework, but there’s an explicit interface for doing so.

## Assorted notes in this general theme

- Providers are like "Rails initializers but with more juice" – they register components in the container. They have lifecycle hooks (prepare, start, stop) for managing resources. They're lazily loaded and can have namespace capabilities for organizing related components.
- Hanami encourages namespacing over Rails' flat structure. "Slices" provide first-class support for modularizing applications like Rails Engines. Each slice has its own container and can have its own providers, creating bounded contexts.
- Hanami uses Zeitwerk for code loading.
* Dev server uses Guard to restart puma in development. Because everything is so modularized, it’s good enough.
* Code is lazy-loaded in development but fully pre-loaded in production.

## Where things are going

In the Hanami Discord, Tim shared a proposal for building out a plugin system for Hanami… and to me looks a lot like Railties and [ActiveSupport lazy load hooks](https://edgeapi.rubyonrails.org/classes/ActiveSupport/LazyLoadHooks.html):

> Using your grant, I propose to implement this Hanami extensions API. The end
> goal will be to:
>
> * Allow all first-party “framework extension code” to move from the core Hanami
> gem back into the respective Hanami subsystem gems (e.g. the core Hanami
> gem should no longer have specific extension logic for views).
> * Allow third-party gems to integrate with Hanami on an equal footing to the first-
> party gems.
>
> This will require building at least some of the following:
>
> * Ability for extensions to be detected by or registered with the Hanami framework.
> * Ability to enhance or replace Hanami CLI commands.
> * Ability to register new configuration settings on the Hanami app.
> * Hooks for extending core Hanami classes.
> * Hooks for adding logic to Hanami’s app boot process.
> * Adjustments to first-party Hanami gems to allow their classes to be used in an un-extended state when required.
> * A separate “extension” gem that can allow Hanami extensions to register their extensions without depending on the main Hanami gem.

### And how this all started

Ending on what I originally shared with Tim to start our discussion, which I share partly cause I think it’s funny how easily I can type out 500 words today on a thesis of like “why code loading in Ruby is hard”:

> **Making boot fast; don’t load the code unless you need it**
>
> Don’t load code until/unless you need it. DEFINITELY don’t create database connections or make any http calls or invoke other services. How Rails does it, Rails autoloads as much as possible (framework, plugin/extension, and application code), either via Ruby Autoload or Zeitwerk. The architecture challenge is: how do you set up configuration properties, so that *when* the code is loaded (and all the different pieces of framework/plugin/extension/application get their fingers on it), it is configured with the properties y’all ultimately want on it? There are two mechanisms:
>
> - A configuration hash, that is intended to be made up (somewhat) of primitives that are dependency free and thus don’t load a bunch of code themselves,
> * A callback hook that is placed within autoloaded code, that one can register against and use it to pull data out of configuration (framework/plugin/extension) or override/overload behavior (your application), that is only triggered when the code is loaded for reals. Extensions put this in a Railtie, maybe you put it in an initializer.,
>  The practical problems are:
>
> * Ideally everything was stateless and just pulled values from configuration and got torn down after every request/transaction/task, but also:
>   * Some objects are long-lived, and you don’t want to constantly be tearing them down,
>   * Sometimes locality of properties is nice and it would be annoying to be like “either use this locally assigned value OR use this value from really far away in this super deep config object”.,
>   * Hopefully that config object is thread and fiber safe if you’re gonna be changing it later and you’re not really sure what’s happening right then in your application lifecycle.,
> * A hook doesn’t exist in the place that you want to hook into, so you either have to:
>   * go upstream and get a hook added; which is annoying (just hook every class and feature, why not?!),
>   * load the code prematurely so you can directly modify it,
> * When something else (framework/plugin/extension/application) prematurely loads the code (chaotically or intentionally), before you add your own configuration or before you register a hook callback, and the behavior is stateful or had to be backed out (example: it’s configuration for connections in a connection pool and early invocation fills the pool with connection objects with premature configuration. So to re-configure you have to drain the pool of the old prematurely configured connections and maybe that’s hard),
> * Examples of pain:
>   * Devise.
>     * It’s route (devise_for) loads your active record model, when routes load, which in < Rails 8.0 was when your app boots, which is premature otherwise,
>     * Changing the layout of devise controllers. They don’t have load hooks (maybe they should?). You can subclass them and manually mount them in your app, but htat’s annoying,
>   * Every initializer where you try to assign config and maybe it won’t work cause something else already hooked it and loaded it and it’s baked.,
>
> **How Hanami does it:**
>
>> @inouire in the Rails Discord shared a couple of links: You can find some information about Hanami way of handling dependency container: [https://guides.hanamirb.org/v2.2/app/container-and-components/](https://guides.hanamirb.org/v2.2/app/container-and-components/) Also autoloading: [https://guides.hanamirb.org/v2.2/app/autoloading/](https://guides.hanamirb.org/v2.2/app/autoloading/) And info about lazy boot: [https://guides.hanamirb.org/v2.2/app/booting/](https://guides.hanamirb.org/v2.2/app/booting/)
>
> Hanami questions from Ben:
> - Components are singletons that are pure-ish functions? Do they get torn down / recreated on every request, or does the same object exist for the lifetime of the application?,
> - Is there a pattern of assigning properties to class variables? Seems like most stuff is pure-ish functions. How do you handle objects that you want to be long-lived, like Twitter::Client.new or something?,
> - I didn’t see plugins/extensions. Are you required to subclass and overload a component or can you poke around in an existing class/component? Can I defer poking around in a component until it’s loaded? (like an autoload hook),
> - Are there any patterns you see people do, that would slow down their hanami app's boot, that you wish they didn't do?
