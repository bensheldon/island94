# frozen_string_literal: true
class Post < ApplicationModel
  attribute :filepath, :string
  attribute :frontmatter, default: -> { {} }
  attribute :body, :string

  def self.all
    # Load all files from _posts directory
    cache[:all] ||= Dir.glob("#{Rails.root}/_posts/**/*.*").map do |filepath|
      Post.from_file(filepath)
    end
  end

  def self.redirects
    cache[:redirects] ||= all.each_with_object({}) do |post, hash|
      post.redirects.each do |redirect|
        hash[redirect] = post
      end
    end
  end

  def self.tags
    all.flat_map(&:tags).uniq.sort
  end

  def self.from_file(path)
    parsed = FrontMatterParser::Parser.parse_file(path)
    new(filepath: path, frontmatter: parsed.front_matter, body: parsed.content)
  end

  def slug
    @_slug ||= raw_slug.downcase
  end

  def project_filepath
    filepath.sub("#{Rails.root}/", "")
  end

  def filename
    File.basename(filepath, '.*')
  end

  def title
    frontmatter.fetch("title", "")
  end

  def content
    @_content ||= Kramdown::Document.new(body, input: 'GFM').to_html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def published_at
    @_published_at ||= Time.zone.parse(frontmatter["date"] || filename.split("-", 3).join("-"))
  end

  def published?
    frontmatter["published"] != false
  end

  def tags
    Array(frontmatter["tags"])
  end

  def redirects
    frontmatter.fetch("redirect_from", []).tap do |redirects|
      redirects << RouteHelper.post_path(self, slug: raw_slug, only_path: true) if raw_slug != slug
    end
  end

  def related_posts
    return [] if tags.empty?

    self.class.all
        .select(&:published?)
        .select { |post| post.tags.intersect?(tags) }
        .reject { |post| post == self }
        .sort_by(&:published_at)
        .last(5).reverse # Limit to 5 related posts
  end

  private

  def raw_slug
    filename.split("-", 4).last
  end
end
