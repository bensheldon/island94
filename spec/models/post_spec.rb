# frozen_string_literal: true
require_relative "../rails_helper"

RSpec.describe Post do
  describe '.load_all' do
    it 'loads all posts from _posts directory' do
      result = described_class.all

      expect(result.size).to be > 1
      expect(result.first).to be_a(described_class)
      expect(result.first.title).to eq("Pool Soup")
    end
  end

  describe '#tags' do
    it 'returns an empty array when tags is absent' do
      post = described_class.new(frontmatter: {})
      expect(post.tags).to eq([])
    end

    it 'returns an array when tags is already an array' do
      post = described_class.new(frontmatter: { "tags" => ["ruby", "rails"] })
      expect(post.tags).to eq(["ruby", "rails"])
    end

    it 'wraps a string tag in an array' do
      post = described_class.new(frontmatter: { "tags" => "ruby" })
      expect(post.tags).to eq(["ruby"])
    end
  end
end
