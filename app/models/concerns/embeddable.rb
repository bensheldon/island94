# frozen_string_literal: true

# Semantic related-document lookup backed by Embeddings.
module Embeddable
  extend ActiveSupport::Concern

  class_methods do
    def embeddings
      cache[:embeddings] ||= Embeddings.new(published)
    end
  end

  # Plain text (title + body) used to generate this record's embedding. Renders
  # markdown without XrubyFilter so drafts' code examples are never executed.
  def embedding_text
    html = Kramdown::Document.new(body.to_s, input: "GFM", syntax_highlighter: nil).to_html
    "#{title}.\n#{Nokogiri::HTML::DocumentFragment.parse(html).text}"
  end

  def semantically_related(limit: 5)
    self.class.embeddings.most_similar(self, limit: limit)
  end
end
