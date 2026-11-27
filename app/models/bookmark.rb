# frozen_string_literal: true
class Bookmark < ApplicationModel
  include Markdownable
  include Embeddable

  attribute :filepath, :string
  attribute :frontmatter, BookmarkFrontmatter.type, default: -> { BookmarkFrontmatter.new }
  attribute :body, :string

  def self.all
    cache[:all] ||= Dir.glob("#{Rails.root}/_bookmarks/**/*.*").map do |filepath|
      Bookmark.from_file(filepath)
    end
  end

  def self.from_file(path)
    parsed = FrontMatterParser::Parser.parse_file(path, loader: BookmarkFrontmatter.method(:from_yaml))
    new(filepath: path, frontmatter: parsed.front_matter, body: parsed.content)
  end

  def self.published
    all.select(&:published?)
  end

  # Creates a new bookmark file on disk. If a bookmark for the same link/date already
  # exists (i.e. the same link was bookmarked twice on the same day), the new notes are
  # appended below the existing content, separated by a horizontal rule, rather than
  # overwriting the file.
  def self.create!(link:, title: nil, tags: nil, notes: nil, date: Time.zone.now)
    link = link.to_s.strip
    raise ArgumentError, "link is required" if link.empty?

    path = filepath_for(link: link, date: date)

    if File.exist?(path)
      File.write(path, "#{File.read(path).rstrip}\n\n---\n\n#{notes}\n")
    else
      frontmatter = BookmarkFrontmatter.new(
        link: link,
        date: date.strftime('%Y-%m-%d %H:%M %Z'),
        title: title,
        tags: tags
      )
      frontmatter.validate!
      write_frontmatter_file(path, frontmatter: frontmatter, body: notes.to_s)
    end

    reset
    from_file(path)
  end

  def self.filepath_for(link:, date:)
    Rails.root.join("_bookmarks", date.strftime('%Y'), "#{generate_slug(link: link, date: date)}.md").to_s
  end

  def self.generate_slug(link:, date:)
    parameterized_link = link.to_s.strip.sub(%r{\Ahttps?://}, "").parameterize[0...150].delete_suffix('-')
    "#{date.strftime('%Y-%m-%d')}-#{parameterized_link}"
  end

  def slug
    @_slug ||= begin
      _year, _month, _day, slug = filename.split("-", 4)
      slug
    end
  end

  def filename
    File.basename(filepath, '.*')
  end

  def project_filepath
    filepath.sub("#{Rails.root}/", "")
  end

  def title
    frontmatter.title.presence || link
  end

  def link
    frontmatter.link.to_s
  end

  delegate :tags, to: :frontmatter

  def link_host
    URI.parse(link).host
  rescue URI::InvalidURIError
    nil
  end

  def date
    if frontmatter.date
      Time.zone.parse(frontmatter.date.to_s)
    else
      File.mtime(filepath)
    end
  end

  def content
    render_markdown(body)
  end

  def related_bookmarks
    @_related_bookmarks ||= semantically_related || []
  end

  def published?
    frontmatter.published
  end
end
