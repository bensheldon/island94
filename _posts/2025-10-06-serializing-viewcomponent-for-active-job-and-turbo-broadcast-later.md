---
title: "Serializing ViewComponent for Active Job and Turbo Broadcast Later"
date: 2025-10-06 14:59 UTC
published: true
tags: [Ruby on Rails]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "e597395a5112c1ea"
  vector: "+Pr4CAEFAAT0+gEK+gUDAhX8+QcHAQIGAPsD9wf3CAX7B/0IB/v3+gcF6gH6+Qf8+fP4AgMF/P/++gMA/AIC+/gBBf4IA/z9/QEC+QP5+vYB+/3+BwH8/QUB/QMLBv8BAv79CP4FCQP89v4D9/8LBP8ABQT8BQcGEgUGBwb5+wADCfAS/wgCBAb//Aj7Cwn59Q7/CQQG+Pv+CAL69QL9AwYGAPv8+Pzy+gf1+/v7ABMB+gUCCP37+/8CDfv+/f0I/QEFAwH69wn1AAX5//75BvkE+w4F+goC+Qf7+QL8BwAL+PkDAPr9BvX19fsB//789/f+//4D+vwDBfwFBvoBBQX39hP/AP8DDwL2Bf77B/v/AQL//v/++wv4//0D/QH5/PYC+Qf9Cfz7AgoEBPwC//L4AwQI+wYG/Pv+AvwJ/AD1BPoC//78BPr4Bf4A/gsF/PvyAv8G+vv3AgYGDP0GCQUF9AP8Agn8/vn1BQMB8fgBCfUA/Aj7AArzCf8G/fsH"
---

I recently started using ViewComponent. I’ve been gradually removing non-omikase libraries from my Rails applications over the past decade, but ViewComponent is alright. I was strongly motivated by Boring Rails’ ["Hotwire components that refresh themselves”](https://boringrails.com/articles/self-updating-components/), cause matching up all the dom ids and stream targets between views/partials and… wherever you put your Stream and Broadcast renderers is a pain.

You might also know me as the GoodJob author. So of course I wanted to have my Hotwire components refresh themselves _later_ and move stream broadcast rendering into a background job. I to simply call `MessagesComponent.add_message(message)` and broadcasts an update _later_ to the correct stream and target that are all nice and compactly stored inside of the View Component:

```ruby
class MessagesComponent < ApplicationComponent
  def self.add_message(message)
    user = message.user
    Turbo::StreamsChannel.broadcast_action_later_to(
      user, :message_list,
      action: :append,
      target: ActionView::RecordIdentifier.dom_id(user, :messages),
      renderable: MessageComponent.serializable(message: message), # <- that right there
      layout: false
    )
  end

  def initialize(user:, messages:)
    @user = user
    @messages = messages
  end

  erb_template <<~HTML
    <%= helpers.turbo_stream_from @user, :message_list %>
    <div id="<%= dom_id(@user, :messages) %>">
      <%= render MessageComponent.with_collection @messages %>
    </div>
  HTML
end
```

That’s a simple example

### Making a renderable work _later_

The ViewComponent team can be really proud of [achieving first-class support Rails](https://github.com/rails/rails/pull/37919) for a library like ViewComponent. Rails already supported views and partials and now it also supports an object that quacks like a `renderable`.

For ViewComponent to be compatible with Turbo Broadcasting _later_, those View Components need to be serializable by Active Job. That’s because Turbo Rail’s `broadcast_*_later_to` takes the arguments it was passed and serializes them into a job so they can be run elsewhere better/faster/stronger.

To serialize a ViewComponent, we need to collect its initialization arguments, so that we can reconstitute it in that _elsewhere_ place where the job is executed and the ViewComponent is re-initialized. To initialize a ViewComponent, you call `new` which calls its `initialize` method. To patch into that, there’s a couple of different strategies I thought of taking:

- Make the developer figure out which properties of an existing ViewComponent (ivars, attributes) should be grabbed and how to do that.
- `prepend` a module method in front of `ViewComponent#initialize`. Our module would always have to be at the top of the ancestors hierarchy, because subclasses might overload `initialize` themselves, so we’d have to have an `inherited` callback that would prepend the module (again) every time that happened
- Simply initialize the ViewComponent via another, more easily interceptable method, when you want it to be serializable.

I respect that ViewComponent really wanted a ViewComponent to be _just like any other Ruby object_ that you create with `new` and `initialize` , but it makes this particular goal, serialization, rather difficult. You can maybe see the ViewComponent maintainers ran into a few problems with initialization themselves: a collection of ViewComponents can optionally have each member initialized with an iteration number, but to do that [ViewComponent has to introspect the `initialize` parameters](https://github.com/ViewComponent/view_component/blob/1ed16e33ad70e45ffc08de3b68760a83d08e912e/lib/view_component/base.rb#L667-L712) to determine if the object implements the iteration parameter to decide whether to send it 🫠 That parameter introspection also means that we can’t simply prepend a redefined generic `initialize(*args, **kwargs)` because that would break the collection feature. Not great 💛

So, given the compromises i’m willing to make between ergonomics and complexity and performance, given my abilities, and my experience, and what I know at this time…. I decided to simply make a new initializing class method, named `serializable`. If I want my ViewComponent to be serializable, I initialize it with `MyComponent.serializable(foo, bar:)`.

```ruby
# frozen_string_literal: true
# config/initializers/view_component.rb
#
# Instantiate a ViewComponents that is (optionally) serializable by Active Job
# but otherwise behaves like a normal ViewComponent. This allows it to be passed
# as a renderable into `broadcast_action_later_to`.
#
# To use, include the `ViewComponent::Serializable` concern:
#
#  class ApplicationComponent < ViewComponent::Base
#    include ViewComponent::Serializable
#  end
#
# And then call `serializable` instead of `new` when instantiating:
#
#   Turbo::StreamsChannel.broadcast_action_later_to(
#     :admin, client, :messages,
#     action: :update,
#     target: ActionView::RecordIdentifier.dom_id(client, :messages),
#     renderable: MessageComponent.serializable(message: message)
#   )
#
module ViewComponent
  module Serializable
    extend ActiveSupport::Concern

    included do
      attr_reader :serializable_args
    end

    class_methods do
      def serializable(*args)
        new(*args).tap do |instance|
          instance.instance_variable_set(:@serializable_args, args)
        end
      end
      ruby2_keywords(:serializable)
    end
  end
end

class ViewComponentSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize?(argument)
    argument.is_a?(ViewComponent::Base) && argument.respond_to?(:serializable_args)
  end

  def serialize(view_component)
    super(
      "component" => view_component.class.name,
      "arguments" => ActiveJob::Arguments.serialize(view_component.serializable_args),
    )
  end

  def deserialize(hash)
    hash["component"].safe_constantize&.new(*ActiveJob::Arguments.deserialize(hash["arguments"]))
  end

  ActiveJob::Serializers.add_serializers(self)
end
```

**Real talk:** I haven't packaged this into a gem. I didn't want to maintain it for everyone, and there’s some View Component features (like collections) it doesn’t handle yet because I haven’t used them (yet). I think this sort of thing is first class behavior for the current state of Rails and Active Job and Turbo, and I'd rather the library maintainers figure out what the best balance of ergonomics, complexity, and performance is for them. I've been gently poking them about it in their Slack; they're great and I believe we can arrive at something even better than this patch I’m running with myself for now 💖
