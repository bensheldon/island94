# frozen_string_literal: true
require_relative "../rails_helper"

RSpec.describe Embeddings do
  let(:vector) { [Array.new(Embeddings::DIMENSIONS) { |i| (i % 255) - 127 }.pack("c*")].pack("m0") }

  describe ".write_entry" do
    let(:path) { Rails.root.join("tmp/embeddings_spec.md").to_s }

    after { FileUtils.rm_f(path) }

    it "appends a single embedding block, leaving the rest of the file byte-for-byte unchanged" do
      original = <<~MD
        ---
        title: "\\"Quoted\\" title"
        date: '2007-07-19'
        tags:
        - advice
        ---

        Body with --- dashes.
      MD
      File.write(path, original)

      described_class.write_entry(path, digest: "0123456789abcdef", vector: vector)

      expect(File.read(path)).to eq(<<~MD)
        ---
        title: "\\"Quoted\\" title"
        date: '2007-07-19'
        tags:
        - advice
        embedding:
          model: "#{Embeddings::MODEL_ID}"
          digest: "0123456789abcdef"
          vector: "#{vector}"
        ---

        Body with --- dashes.
      MD
    end

    it "replaces an existing embedding block instead of duplicating it" do
      File.write(path, "---\ntitle: Hi\nembedding:\n  model: old\n  digest: old\n  vector: old\ntags: []\n---\nBody\n")

      described_class.write_entry(path, digest: "0123456789abcdef", vector: vector)

      content = File.read(path)
      expect(content.scan(/^embedding:/).size).to eq(1)
      expect(content).to include("tags: []\n").and end_with("---\nBody\n")
      frontmatter = FrontMatterParser::Parser.parse_file(path).front_matter
      expect(frontmatter["title"]).to eq("Hi")
      expect(frontmatter["embedding"]).to eq(
        "model" => Embeddings::MODEL_ID, "digest" => "0123456789abcdef", "vector" => vector
      )
      expect(described_class.stored_vector(Post.from_file(path))).to be_present
    end
  end

  describe "stored front matter" do
    it "is well-formed wherever an embedding is present" do
      records = Post.all + Bookmark.all
      invalid = records.select do |record|
        entry = record.frontmatter["embedding"]
        next false if entry.nil?

        !(entry.is_a?(Hash) && entry.keys.sort == %w[digest model vector] &&
          entry["digest"].to_s.match?(/\A\h{16}\z/) && described_class.stored_vector(record))
      end

      expect(invalid.map(&:project_filepath)).to be_empty
    end
  end
end
