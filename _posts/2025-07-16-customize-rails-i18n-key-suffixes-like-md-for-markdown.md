---
title: "How to customize Rails I18n key suffixes like `_md` for Markdown"
date: 2025-07-16 10:00 UTC
published: true
tags: [Rails, i18n]
embedding:
  model: "sentence-transformers/all-MiniLM-L6-v2@1110a243:v3"
  digest: "a3c5fc02c7357f41"
  vector: "+AP8/gMFA/4B/v8HBgD9AwEI/QEEBgUNA/78/wQBBPQCAAUMA/oGAAH9/v8D/v//+fz6Afz9+vX88wEF+Av//wEG/QIBDfv9AgYAAAT/+f3/+gQH//f//QkCAPcNCAQCBgH7AwH/AfX4/gUHAfkCAf0DAAEI+AsCAAn8B/cA/gADCQD++QHt8fr/B/z/Afz8AgYICAEA+wD9DP77+AH19/7/Av0F/fb+AQD5BAcDAgYC9PgBAwH8AwYED/oA+AYEA/UH/v/87gX/DQH1+/kKAgL+/foK/QH4/fwA9fz3/gAJ+P8J9fsNEg/5BfYA9wX9/QIIAvb89gv+CfcK+/4BBQAA7AT6AQAEDgwABf8J9gMA/QH79AD+8wED8/z6AAj4BvsDAQT5DPYAAAkC/wQC/fz+/wMFAfQV/wEDA/wJ/AD8AvkA9wf89gL3/v33+u4G+Q8BAfsIAQECDPAIBfkO/wIG+wcDAAsKCvvt+vgA9wD++QT2/AQC+gT/BgEG9gID"
---

If you’ve had reason to use internationalization in Rails on Rails, you’ve probably used a [nifty feature](https://guides.rubyonrails.org/i18n.html#using-safe-html-translations) of it:

> Keys with a `_html` suffix… are marked as HTML safe. When you use them in views the HTML will not be escaped.

Authoring HTML within translations can be a pain because HTML is quite verbose and easy to mess up when maintaining multiple versions of the same phrase, or paragraph, or page across multiple languages.

It would be nice 💅 to have something like this:

> Keys with a `_md` suffix can be authored in Markdown and will be automatically converted to HTML and marked as HTML safe.

Markdown is a lot less verbose than HTML and easier to write and eyeball. Let’s do it!

First, we have to patch into the I18n `translate` method. It looks something like this:

```ruby
# config/initializers/markdown.rb

module Markdown
  module I18nBackendExt
    def translate(locale, key, options)
      result = super
      # Rails missing key returns as MISSING_TRANSLATION => -(2**60) => -1152921504606846976
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

ActiveSupport.on_load(:i18n) do
  I18n.backend.class.prepend Markdown::I18nBackendExt
end
```

**Fun Fact:** Rails does a clever thing to detect missing translations. I18n accepts a stack of fallback defaults, and Rails [appends a magic number](https://github.com/rails/rails/pull/45572) to the back of that stack: `-(2**60) => -1152921504606846976`. If a translation ever returns that value, Rails assumes that the translation fell through the entire fallback stack and is therefore missing. (It took me a bit of sleuthing to figure out what the heck this weird number meant while poking around.)

Second, we patch the Rails HTML Safe behavior to _also_ make these strings HTML safe too:

```ruby
# config/initializers/markdown.rb

module Markdown
  module HtmlSafeTranslationExt
    def html_safe_translation_key?(key)
      key.to_s.end_with?("_md") || super
    end
  end
end

ActiveSupport::HtmlSafeTranslation.prepend Markdown::HtmlSafeTranslationExt
```

That’s pretty much it!

If you’re uncomfortable patching things, Tim Masliuchenko has a gem called [`I18n::Transformers`](https://github.com/timfjord/i18n-transformers) that makes it easy create custom key-based transformations. I believe you’ll still need to patch into the HTML safety behavior of Rails though—and anything involving marking things as HTML-safe should be always be scrutinized for [XSS](https://guides.rubyonrails.org/security.html#cross-site-scripting-xss) potential.

Here’s the full initializer I have, including how I get Kramdown to create “inline” markdown:

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
      smart_quotes: ["apos", "apos", "quot", "quot"] # disable smart quotes
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
