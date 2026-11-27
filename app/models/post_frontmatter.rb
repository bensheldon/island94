# frozen_string_literal: true
class PostFrontmatter < BaseFrontmatter
  attribute :title, :string
  attribute :date # kept as written (e.g. "2024-01-01 10:00 UTC"); parsed by Post
  attribute :published, :boolean, default: true
  attribute :tags, default: -> { [] }
  attribute :embedding # managed by Embeddings
  attribute :redirect_from, default: -> { [] }

  validates :title, presence: true

  def tags=(value)
    super(Array(value))
  end

  def redirect_from=(value)
    super(Array(value))
  end
end
