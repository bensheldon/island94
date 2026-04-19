# frozen_string_literal: true
require "open3"

class Pagefind
  OUTPUT_PATH      = Rails.public_path.join('pagefind').freeze
  HASH_FILE        = Rails.root.join("tmp/pagefind.hash").freeze
  WATCHED_PATTERNS = [ "_posts/*.md" ].freeze

  def self.build
    new.build
  end

  def build
    cache_key = mtime_cache_key

    if File.exist?(HASH_FILE) && File.read(HASH_FILE) == cache_key && File.exist?(OUTPUT_PATH.join("pagefind.js"))
      Rails.logger.debug "Pagefind index up to date, skipping build"
      return
    end

    json = search_json

    script = <<~JS
      import * as pagefind from "pagefind";

      const searchData = #{json};
      const outputPath = #{OUTPUT_PATH.to_s.to_json};

      const { index } = await pagefind.createIndex({ forceLanguage: "en" });

      for (const item of Object.values(searchData)) {
        const { errors } = await index.addCustomRecord({
          url: item.url,
          content: item.title + "\n" + (Array.isArray(item.tags) ? item.tags : [item.tags]).join(" ") + "\n" + item.content,
          language: "en",
          meta: { title: item.title, published: item.published },
          filters: { tags: item.tags },
        });
        if (errors.length) console.error("Pagefind errors for", item.url, errors);
      }

      const { errors } = await index.writeFiles({ outputPath });
      if (errors.length) {
        console.error("Pagefind write errors:", errors);
        process.exit(1);
      }

      console.log(`Pagefind indexed ${Object.keys(searchData).length} records`);
    JS

    output, status = Open3.capture2e("node --input-type=module", stdin_data: script, chdir: Rails.root.to_s)
    Rails.logger.info output
    raise "Pagefind build failed" unless status.success?

    File.write(HASH_FILE, cache_key)
  end

  private

  def mtime_cache_key
    WATCHED_PATTERNS.flat_map { |pattern| Dir[Rails.root.join(pattern)] }.filter_map { |f| File.mtime(f).to_i }.sort.join(",")
  end

  def search_json
    helpers = ActionController::Base.helpers
    Post.all.sort_by(&:published_at).reverse.to_h do |post|
      url = "/#{post.published_at.strftime('%Y/%m')}/#{post.slug}"
      [
        url.delete_prefix('/').parameterize,
        {
          title: post.title,
          published: post.published_at.strftime("%B %-d, %Y"),
          tags: post.tags,
          content: helpers.strip_tags(post.content),
          url: url,
        },
      ]
    end.to_json
  end
end
