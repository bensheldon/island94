# frozen_string_literal: true
class Bookmark < ApplicationModel
  attribute :filepath, :string
  attribute :frontmatter, default: -> { {} }
  attribute :body, :string

  def self.all
    cache[:all] ||= Dir.glob("#{Rails.root}/_bookmarks/**/*.*").map do |filepath|
      Bookmark.from_file(filepath)
    end
  end

  def self.from_file(path)
    parsed = FrontMatterParser::Parser.parse_file(path)
    new(filepath: path, frontmatter: parsed.front_matter, body: parsed.content)
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
    frontmatter.fetch("title", link)
  end

  def link
    frontmatter.fetch("link", "")
  end

  def link_host
    URI.parse(link).host
  rescue URI::InvalidURIError
    nil
  end

  def date
    if frontmatter["date"]
      Time.zone.parse(frontmatter["date"])
    else
      File.mtime(filepath)
    end
  end

  def content
    Kramdown::Document.new(body, input: 'GFM').to_html.html_safe # rubocop:disable Rails/OutputSafety
  end
end
