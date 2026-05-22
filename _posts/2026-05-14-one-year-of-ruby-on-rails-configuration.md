---
title: "One year of Ruby on Rails configuration"
date: 2026-05-14 19:13 UTC
published: true
tags: [Ruby, "Ruby on Rails"]
---

I've been working professionaly with Ruby on Rails for nearly 15 years (I'm also the author of GoodJob and Spectator Sport). Last year I left GitHub and co-founded a technology startup, [Frontdoor Benefits](https://www.openfrontdoor.com/), that helps people enroll and manage their US government welfare benefits like SNAP/EBT.

Therefore, I've been working in a fresh Ruby on Rails app full-time now for 1 year. One of the Rails pillars is ["convention over configuration"](https://rubyonrails.org/doctrine), so I thought it would be fun to share what has so far accumulated in my app's `/config` directory: monkeypatches, extensions, and appwide behaviors.

Let's start with the most controversial one.

### `Object#not_nil?` and boolean extensions

```ruby
# config/extensions/ext_object_boolean_nil.rb

class Object
  def not_nil?
    !nil?
  end

  def false?
    false
  end

  def true?
    false
  end
end

class FalseClass
  def false?
    true
  end
end

class TrueClass
  def true?
    true
  end
end
```

I realize there are PhDs written about the evils of null. I DISAGREE. I am continually confronted with the need to distnguish between "Yes", "No", and "has not answered the question yet" in my my [wide models](https://island94.org/2025/04/wide-models-and-active-record-custom-validation-contexts). I want a simple predicate pair like `present?`/`blank?` for `nil` , hence `nil?` /`not_nil?` .

And then you can see where that led me wanting to distinguish between truthy and falsey and *true* true and *false* false. Predicates are great!

### `timestamptz` default

```ruby
# config/initializers/active_record_timezones.rb

ActiveSupport.on_load(:active_record_postgresqladapter) do
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.datetime_type = :timestamptz
end
```

I write my database migrations using `table.datetime` and it generates `timestamptz` columns.  I guess this is fine.

### `Capybara.threadsafe`
```ruby
# config/initializers/capybara.rb

Capybara.threadsafe = true
```

I use Capybara as my harness for webdriving automations, rather than writing raw Selenium (never again!).

### Custom Types
```ruby
# config/initializers/custom_types.rb

Rails.application.config.to_prepare do
  ActiveRecord::Type.register(:phone_number, PhoneNumber::Attribute)
  ActiveModel::Type.register(:phone_number, PhoneNumber::Attribute)
end

module Kernel
  def PhoneNumber(value) # rubocop:disable Naming/MethodName
    value.is_a?(PhoneNumber) ? value : PhoneNumber.new(value)
  end
end
```

There are several annoyances here:
- I have to register custom attributes twice: once for Active Record and once for Active Model.
- I want my types to live in `/app`, and be autoloaded, but there isn't a lifecycle hook for that

And one celebration: I love Ruby and being able to coerce with`PhoneNumber(something)`

### `dom_target`

```ruby
# config/initializers/extend_action_view_record_identifier.rb

module ActionView
  module RecordIdentifier
    def dom_target(*objects)
      objects.map do |object|
        if object.is_a?(Symbol) || object.is_a?(String)
          object
        elsif object.is_a?(Class)
          dom_class(object)
        else
          dom_id(object)
        end
      end.join(JOIN)
    end
  end
end
```

I write a lot of Turbo and I want to be able to chain together an unlimited list of identifiers like `(:admin, client, :outbound, Message, :new)` to produce something like `admin_client_24_outbound_message_new` to pair up Turbo Streams and Broadcasts. I [upstreamed this into Rails 8.1](https://github.com/rails/rails/pull/55204) so this is unecessary now🎉

### `field_error_proc`

```ruby
# config/initializers/form_errors.rb

ActiveSupport.on_load(:action_view) do
  ActionView::Base.field_error_proc = proc do |html_tag, _instance_tag|
    html_tag
  end
end
```

Still necessary 🫥

### GoodJob and UUIDv7

```ruby
# config/initializers/good_job.rb

Rails.application.configure do
  config.good_job.execution_mode = :inline if Rails.env.test?
end

GoodJob.preserve_job_records = true
GoodJob.on_thread_error = ->(exception) { Appsignal.send_error(exception) }

ActiveSupport.on_load(:action_mailer) do
  ActionMailer::MailDeliveryJob.retry_on StandardError, wait: :polynomially_longer, attempts: Float::INFINITY
  ActionMailer::MailDeliveryJob.discard_on ActiveJob::DeserializationError
end

# **SNIP** Lots of GoodJob cron config

module ActiveJobUUIDv7
  def initialize(*args)
    super
    @job_id = SecureRandom.uuid_v7
  end
  ruby2_keywords(:initialize)
end

ActiveSupport.on_load(:active_job) do
  include ActiveJobUUIDv7
end

ActiveSupport.on_load(:good_job_execution) do
  before_create { self.id ||= SecureRandom.uuid_v7 }
end

ActiveSupport.on_load(:good_job_process) do
  before_create { self.id ||= SecureRandom.uuid_v7 }
end

ActiveSupport.on_load(:good_job_batch_record) do
  before_create { self.id ||= SecureRandom.uuid_v7 }
end

ActiveSupport.on_load(:good_job_setting) do
  before_create { self.id ||= SecureRandom.uuid_v7 }
end
```

A surprising misconception I've run across with folks using GoodJob is that using _more_ configuration is better. Less less less.

Specifically at the bottom, I've [patched GoodJob and Active Job to use UUIDv7](https://github.com/bensheldon/good_job/issues/1698) to see if it's any better. The verdict is still out. It's not worse!

### I18n verification

```ruby
# config/initializers/i18n_verify

return unless Rails.configuration.i18n.raise_on_missing_translations

IGNORED_I18N_KEYS = %w[
  activerecord.attributes.client.reports
  ...
].freeze

module I18n
  class << self
    alias original_translate t

    def translate(key, **options)
      begin
        original_fallbacks = I18n.fallbacks
        I18n.fallbacks = I18n.available_locales.index_with { |locale| [locale] }

        ignored = IGNORED_I18N_KEYS.any? { |k| [options[:scope], key].compact.join(".").start_with?(k) }
        unless ignored
          available_locales.without(I18n.locale).each do |locale|
            with_locale(locale) { original_translate(key, **options, raise: true) }
          end
        end
      ensure
        I18n.fallbacks = original_fallbacks
      end

      original_translate(key, **options)
    end
  end
end
```

This is a fun patch that causes `I18n.raise_on_missing_translations` to raise on any missing translation across *all available locales*, not just the current locale.

### `i18n_tasks` / Psych YAML mangling

```ruby
# config/initializers/i18n_tasks_normalize.rb

# Drop this at the top of config/i18n_tasks.yml too:
# <% require "./config/i18n_tasks_normalize" %>

module I18nTaskYamlExt
  UNMASKED_EMOJI = /
    (?:
      (?:\p{Emoji_Presentation}|\p{Emoji}\uFE0F)   # base emoji
      (?:\u200D(?:\p{Emoji_Presentation}|\p{Emoji}\uFE0F))* # + ZWJ parts
    )
  /ux

  def dump(tree, options)
    builder = Psych::Visitors::YAMLTree.create
    builder << tree
    ast = builder.tree
    _process_node(ast)
    strip_trailing_spaces(restore_emojis(ast.to_yaml(nil, options || {})))
  end

  private

  def _process_node(node)
    case node
    when Psych::Nodes::Scalar
      node.plain = false
      node.quoted = true
      node.style = node.value.include?("\n") ? Psych::Nodes::Scalar::LITERAL : Psych::Nodes::Scalar::DOUBLE_QUOTED # <== THE ENTIRE PURPOSE OF THIS MONKEYPATCH 🫠
      node.value = _mask_emoji(node.value) if node.style == Psych::Nodes::Scalar::LITERAL # pre-mask emoji because otherwise libyaml will double-quote when we want literal style
    when Psych::Nodes::Mapping
      # only process the values, not the keys
      node.children.each_slice(2) { |_key, value| _process_node(value) }
    when Psych::Nodes::Stream, Psych::Nodes::Document, Psych::Nodes::Sequence
      node.children.each { |node| _process_node(node) }
    else
      raise "not handling #{node.inspect}"
    end
  end

  # libyaml will do this, but we want to do it first so that libyaml doesn't _also_
  # mark the node as unprintable and thus prevent it from being in a literal
  # https://github.com/yaml/libyaml/issues/279
  # "Hello 👋 world 🌍!" => "Hello \\u0001F44B world \\u0001F30D!"
  def _mask_emoji(string)
    string.gsub(UNMASKED_EMOJI) do |emoji|
      emoji.codepoints
        .map { |cp| format('\\u%08X', cp) }
        .join
    end
  end
end

I18n::Tasks::Data::Adapter::YamlAdapter.singleton_class.prepend I18nTaskYamlExt
```

Ok, `i18n_tasks` is absolutely essential for doing localization. But it works by roundtripping your YAML through Psych.  This patch does 2 things:

- It makes Psych output every string as _strictly either_ a doublequoted string or, if it contains a newline, as literal-block (`key: |`). Without the patch, Psych will swap around single and doublequoted strings and convert literal-blocks to double-quoted strings with `\n`s
- Emojis don't get mangled.

### Custom mailers

```ruby
# config/initializers/mailers.rb

ActiveSupport.on_load(:action_mailer) do
  ActionMailer::Base.add_delivery_method :twilio_sms, TwilioSmsDelivery
  ActionMailer::Base.add_delivery_method :null, NullDelivery
end
```

I'm one of the rare true-fans of Action Mailer who wants to deliver messages to *more* channels via Action Mailer, not none.  Our app uses Action Mailer to construct and deliver SMS messages too via a custom delivery method. I've [touched on](https://island94.org/2024/10/technical-reflection-on-disaster-relief-assistance-for-immigrants) this previously.

### Markdown

```ruby
# config/initializers/markdown.rb

module Markdown
  def self.convert(text = nil, **options)
    raise ArgumentError, "Can't provide both text and block" if text && block_given?

    text = yield if block_given?
    return "" unless text

    text = text.to_s.strip_heredoc
    options = options.reverse_merge(
      auto_ids: false,
      smart_quotes: ["apos", "apos", "quot", "quot"], # disable smart quotes
      input: 'GFM',
      hard_wrap: true # turn single newlines into <br />
    )
    Kramdown::Document.new(text, options).to_html
  end

  def self.inline(text = nil, **)
    # Custom input parser defined in Kramdown::Parser::Inline
    convert(text, input: "Inline", **).strip
  end

  module HtmlSafeTranslationExt
    def html_safe_translation_key?(key)
      key.to_s.end_with?("_md") || super
    end
  end

  module I18nBackendExt
    def translate(locale, key, options)
      result = super
      # Rails missing key returns as MISSING_TRANSLATION => (2**60) => -1152921504606846976
      if key.to_s.end_with?("_md") && result.is_a?(String)
        if result.include?("\n")
          Markdown.convert(result)
        else
          Markdown.inline(result)
        end
      else
        result
      end
    end
  end
end

ActiveSupport::HtmlSafeTranslation.prepend Markdown::HtmlSafeTranslationExt
ActiveSupport.on_load(:i18n) do
  I18n.backend.class.prepend Markdown::I18nBackendExt
end

# Generate HTML from Markdown without any block-level elements (p, etc.)
# http://stackoverflow.com/a/30468100/241735
module Kramdown
  module Parser
    class Inline < Kramdown::Parser::Kramdown
      def initialize(source, options)
        super
        @block_parsers = []
      end
    end
  end
end
```

There's two features here:

- `Markdown.convert(string)` and `Markdown.inline(string)` are simple helpers that turn a string of markdown formatted text into html
- The entirety rest of the code duplicates Rails i18n behavior for html-safing `_html` keys. Any i18n key that ends in `_md` will convert the value from markdown to html, and then mark it as html safe. I love authoring complex i18n keys in markdown (especially when `i18n_tasks`/Psych doesn't mangle the newlines, see previously).

### `rbtrace`

```ruby
# config/initializers/rbtrace.rb
if ENV['RBTRACE']
  require 'rbtrace'

  $stdout.puts "Enabled rbtrace. Example commands:"
  $stdout.puts "- Show all method calls: $ bundle exec rbtrace --pid #{Process.pid} --firehose"
  $stdout.puts "- Debug Rails deadlock: $ bundle exec rbtrace --pid #{Process.pid} --eval \"puts output = ActionDispatch::DebugLocks.new(nil).send(:render_details, nil); output\""
  $stdout.puts <<~TEXT
    - Show all threads: $ bundle exec rbtrace --pid #{Process.pid} --eval "ObjectSpace.each_object(::Thread).to_a.each { puts(it, it.backtrace_locations, '------') }; nil"
  TEXT
  $stdout.puts "- Heap Dump: $ bundle exec rbtrace --pid #{Process.pid} --eval 'Thread.new{require \"objspace\"; GC.start; io=File.open(\"tmp/ruby-heap.\#{Time.now.to_i}.dump\", \"w\"); ObjectSpace.dump_all(output: io); io.close }'"
  $stdout.puts 'Press Enter to continue...'
  $stdin.gets
end
```

I have a terrible memory for debugging commands. so this is how I document them. I pair this with a `bin/productionrails` script that allows me to boot a Rails in production-mode locally by setting up all the necessary environment variables with placeholder values, and disabling https and so forth.

### Sprocket Reproducible Assets

```ruby
# config/initializers/sprockets.rb

Rails.application.configure do
  config.assets.gzip = false
end
```

Gzipped Sprocket include the build time and thus are uncacheable across builds. I'm waiting for [someone to look at my PR](https://github.com/rails/sprockets/pull/821).🤷

### Turbo Stream jobs

```ruby
# config/initializers/turbo.rb

ActiveSupport.on_load(:active_job) do
  Turbo::Streams::BroadcastJob.queue_name = "turbo"
  Turbo::Streams::ActionBroadcastJob.queue_name = "turbo"
  Turbo::Streams::BroadcastStreamJob.queue_name = "turbo"
end
```

Somone should make this a configuration option 🫵

### View Components that can `broadcast_later`

```ruby
# config/initializers/view_component.rb

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
  def klass
    ViewComponent::Base
  end

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

I only use View Components in the complex parts of my app, *and* the complex parts of my app are complex because they do a lot of [Turbo Streaming and asynchronous updating](https://thoughtbot.com/blog/hotwire-turbo-streaming-viewcomponents). I shared this upstream with View Component and it's happening, though I [already can imagine ways to do this better](https://github.com/ViewComponent/view_component/pull/2595#issuecomment-4201048398).

### Git Worktree Support

This set of things is rather sprawling. I have a [`GitWorktree` class](https://gist.github.com/bensheldon/f475a2669d72256545df5e2fcd1a4dae) that fetches the current Git Worktree name, and then uses either the string, or a deterministic integer, to prevent collisions during development and testing (itself with `parallel_tests`) across multiple worktrees concurrently:

```yaml
# database.yml
development:
  database: frontdoor_development<%= GitWorktree.db_suffix %>
test:
  development: database: frontdoor_test<%= GitWorktree.db_suffix %><%= ENV["TEST_ENV_NUMBER"].then { it.present? ? "_#{it}" : "" } %>
```

```ruby
# puma.rb
port ENV.fetch("PORT", GitWorktree.integer(3000..3999))

# application.rb
config.x.session_prefix = "frontdoor"
if Rails.env.development?
  port = ENV.fetch("PORT", GitWorktree.integer(3000..3999))
  config.x.session_prefix = "frontdoor_#{port}"
end
config.session_store :cookie_store, key: "_#{config.x.session_prefix}_session"

# spec/support/capybara.rb
Capybara.server_port = GitWorktree.integer(4000..4990, stride: ENV.fetch("PARALLEL_TEST_GROUPS", 1).to_i) + ENV.fetch("TEST_ENV_NUMBER", 0).to_i
```
