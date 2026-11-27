# frozen_string_literal: true
class Post < ApplicationModel
  include Markdownable
  include Embeddable

  MEDIA_URL_ATTRIBUTES = %w[src href].freeze

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
    published.flat_map(&:tags).uniq(&:parameterize).sort_by(&:downcase)
  end

  def self.published
    all.select(&:published?)
  end

  def self.from_file(path)
    parsed = FrontMatterParser::Parser.parse_file(path)
    new(filepath: path, frontmatter: parsed.front_matter, body: parsed.content)
  end

  # Creates a new post file on disk. Raises if a post with the same title/date already exists.
  def self.create!(title:, body: nil, date: Time.zone.now, **extra_frontmatter)
    title = title.to_s.strip
    raise ArgumentError, "title is required" if title.empty?

    path = filepath_for(title: title, date: date)
    frontmatter = {
      "title" => title,
      "date" => date.strftime('%Y-%m-%d %H:%M %Z'),
      "published" => true,
      "tags" => [],
    }.merge(extra_frontmatter.stringify_keys)
    body = <<~MARKDOWN.strip
      #{body}

      <blockquote markdown="1">



      </blockquote>
    MARKDOWN

    write_frontmatter_file(path, frontmatter: frontmatter, body: body)

    reset
    from_file(path)
  end

  def self.filepath_for(title:, date:)
    Rails.root.join("_posts", "#{date.strftime('%Y-%m-%d')}-#{title.parameterize}.md").to_s
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

  def content(base_url: nil)
    @_content ||= render_markdown(body)
    return @_content unless base_url

    rewrite_media_urls(@_content, base_url)
  end

  def published_at
    @_published_at ||= Time.zone.parse(frontmatter["date"] || filename.split("-", 3).join("-"))
  end

  def published?
    frontmatter["published"] != false
  end

  def tags
    Array(frontmatter["tags"]).uniq(&:parameterize)
  end

  def tag_slugs
    tags.map(&:parameterize)
  end

  def redirects
    frontmatter.fetch("redirect_from", []).tap do |redirects|
      redirects << RouteHelper.post_path(self, slug: raw_slug, only_path: true) if raw_slug != slug
    end
  end

  RELATED_POSTS_LIMIT = 5

  def related_posts
    @_related_posts ||= semantic_related_posts || tag_related_posts
  end

  private

  def semantic_related_posts
    semantically_related(limit: RELATED_POSTS_LIMIT).presence
  end

  def tag_related_posts
    return [] if tags.empty?

    self.class.published
        .select { |post| post.tag_slugs.intersect?(tag_slugs) }
        .reject { |post| post.project_filepath == project_filepath }
        .sort_by(&:published_at)
        .last(RELATED_POSTS_LIMIT).reverse
  end

  def rewrite_media_urls(html, base_url)
    fragment = Nokogiri::HTML::DocumentFragment.parse(html)

    fragment.css("[src], [href]").each do |element|
      MEDIA_URL_ATTRIBUTES.each do |attribute|
        value = element[attribute]
        next unless value&.start_with?("/")

        element[attribute] = URI.join(base_url, value).to_s
      end
    end

    fragment.to_html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def raw_slug
    filename.split("-", 4).last
  end
end
