---
title: "Serializing ViewComponent for Active Job and Turbo broadcast later"
date: 2025-09-14 14:17 UTC
published: true
tags: [Ruby, Ruby on rails]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "31726132632741d2"
  vector: "+Pn5CAEEAQXz+wEK+wUBAhb8+QYIAAIFAPwD9wj3Bwb7B/0IB/z3+QYG6gD69wj7+PT4AwQD/P//+gL++wIC+vgBBf8IBf39/QIC+AP4+vYB/f3+BwH8/QUA/AQLBf8AA/79B/4FCQT89v4E9wALBf8ABwT9BggFEQUHBwj4+gACCfES/wgBBAYA/gn7Cwr59g7+CAIG9/z+BgP79AL/AgUG//v89/7y+gb2+/v7ARIB+gQDCfz6/P8CD/r9/v0H/QAFAwH79wn2/wb5/v76BvoE+w8F+goB+Qn7+gH+BwAM9/oEAPr8BfXz9fwAAPz99/f+//4E+v0CBfsEBvkBBQb29hL/AP8FDQP5BP77B/kAAgL////++wz4AP0D/QL7+vYC+gj9CPz7AAoDBPwD/vL4AgEH+wUF/Pv/AfwH/AD0BfwBAP79A/v4Bv0B/gwE/fvyBP8G+v73AwYFDAAGCwUF9QP7AQj8//j2BwQC8vcBCfX//Af7/wv1CAAH/voH"
---

I recently started using ViewComponent. I’ve been gradually removing non-omikase libraries from my Rails applications over the past decade, but ViewComponent is alright. I was strongly motivated by Boring Rails’ ["Hotwire components that refresh themselves”](https://boringrails.com/articles/self-updating-components/), cause matching up all the dom ids and stream targets between views/partials and …. wherever you put your Stream and Broadcast renderers is a pain.

You might be familiar with me as the GoodJob author. So of course I wanted to have my Hotwire components refresh themselves _later_ and move stream broadcast rendering into a background job. I simply call `MessagesComponent.add_message(message)` and broadcasts an update _later_ to the correct stream and target that are all nice and local when defined inside the View Component:

```ruby
class MessageListComponent < ApplicationComponent
  def self.add_message(message)
    user = message.user
    Turbo::StreamsChannel.broadcast_action_later_to(
      user, :message_list,
      action: :append,
      target: ActionView::RecordIdentifier.dom_id(user, :message_list),
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
    <div id="<%= dom_id(@user, :message_list) %>">
      <%= render MessageComponent.with_collection @messages %>
    </div>
  HTML
end
```

That’s a simple example.

### Making a renderable work _later_

The ViewComponent team can be really proud of [adding first-class support to Rails](https://github.com/rails/rails/pull/37919) for a library like ViewComponent. Rails already supported views and partials and now it also supports an object that quacks like a `renderable` .

For ViewComponent to be compatible with Turbo Broadcasting _later_, those View Components need to be serializable by Active Job. That’s because Turbo Rail’s `broadcast_*_later_to` takes the arguments it was passed and serializes them into a job so they can be run elsewhere better/faster/stronger.

To serialize a ViewComponent, we need to collect its initialization arguments so that we can reconstitute it in that _elsewhere_ place where the job is executed and the ViewComponent is re-initialized. To initialize a ViewComponent, you call `new` which calls its `initialize` method. To patch into that, there are a couple of different strategies I thought of taking:

- Make the developer figure out which properties of an existing ViewComponent (ivars, attributes) should be grabbed and how to do that.

- `prepend` a module method in front of `ViewComponent#initialize`. Our module would always have to be at the top of the ancestors hierarchy, because subclasses might overload `initialize` themselves, so we’d have to have an `inherited` callback that would prepend the module (again) every time that happened

- Simply initialize the ViewComponent via another, more easily interceptable method, when you want it to be serializable.

I respect that ViewComponent maintainers really want a ViewComponent to be _just like any other Ruby object_ that you create with `new` and `initialize` , but it makes this particular goal, serialization, rather difficult. You can maybe see the ViewComponent maintainers ran into a few problems with initialization themselves: a collection of ViewComponents can optionally have each member initialized with an iteration number, but to do that [ViewComponent has to introspect the `initialize` parameters](https://github.com/ViewComponent/view_component/blob/1ed16e33ad70e45ffc08de3b68760a83d08e912e/lib/view_component/base.rb#L667-L712) to determine if the object implements the iteration parameter to decide whether to send it 🫠 That parameter introspection also means that we can’t simply prepend a redefined generic `initialize(*args, **kwargs)` because that would break the collection feature. Not great 💛

So, given the compromises I’m willing to make between ergonomics and complexity and performance, given my abilities, and my experience, and what I know at this time…. I decided to simply make a new initializing class method, named `serializable`. If I want my ViewComponent to be serializable, I initialize it with `MyComponent.serializable(foo, bar:)`.

```ruby
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
#     :admin, user, :messages,
#     action: :update,
#     target: ActionView::RecordIdentifier.dom_id(user, :messages),
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

**Real talk:** I haven't packaged this into a gem. I didn't want to maintain it for everyone, and there are some View Component features (like collections) it doesn’t handle yet because I haven’t used them (yet). I think this sort of thing is first-class behavior for the current state of Rails and Active Job and Turbo, and I'd rather the library maintainers figure out what the best balance of ergonomics, complexity, and performance is for them. I've been gently poking them about it in their Slack; they're great 💖
