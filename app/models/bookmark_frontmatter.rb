# frozen_string_literal: true
class BookmarkFrontmatter < BaseFrontmatter
  attribute :link, :string
  attribute :date # kept as written (e.g. "2024-01-01 10:00 UTC"); parsed by Bookmark
  attribute :published, :boolean, default: true
  attribute :title, :string
  attribute :tags, default: -> { [] }
  attribute :embedding # managed by Embeddings

  validates :link, presence: true

  # An explicit blank `published:` means unpublished; a missing key defaults to true.
  def published=(value)
    super(value.nil? ? false : value)
  end

  def tags=(value)
    super(Array(value))
  end
end
