# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PostFrontmatter do
  it 'casts known keys and preserves unknown keys' do
    frontmatter = described_class.new("title" => "Hi", "tags" => "ruby", "layout" => "post")

    expect(frontmatter.tags).to eq(["ruby"])
    expect(frontmatter.published).to be(true)
    expect(frontmatter["layout"]).to eq("post")
    expect(frontmatter.to_h).to eq("title" => "Hi", "published" => true, "tags" => ["ruby"], "redirect_from" => [], "layout" => "post")
  end

  it 'requires a title' do
    expect(described_class.new).not_to be_valid
  end

  it 'is assignable from a Hash on Post' do
    post = Post.new(frontmatter: { "title" => "Hi" })

    expect(post.frontmatter).to be_a(described_class)
    expect(post.title).to eq("Hi")
  end

  it 'round-trips through YAML' do
    yaml = "title: Hi\ndate: 2024-01-01 10:00 UTC\ntags: [ruby]\nlayout: post\n"
    frontmatter = described_class.from_yaml(yaml)

    expect(frontmatter.title).to eq("Hi")
    expect(frontmatter.date).to eq("2024-01-01 10:00 UTC")
    expect(described_class.from_yaml(frontmatter.to_yaml)).to eq(frontmatter)
  end

  it 'deserializes empty YAML' do
    expect(described_class.from_yaml("")).to eq(described_class.new)
  end
end
