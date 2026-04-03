# frozen_string_literal: true
require "open3"
require "digest"

class Pagefind
  OUTPUT_PATH = Rails.root.join("public/pagefind").freeze
  HASH_FILE   = Rails.root.join("tmp/pagefind.hash").freeze

  def self.build
    new.build
  end

  def build
    json = search_json
    hash = Digest::SHA256.hexdigest(json)

    if File.exist?(HASH_FILE) && File.read(HASH_FILE) == hash && File.exist?(OUTPUT_PATH)
      puts "Pagefind index up to date, skipping build"
      return
    end

    script = <<~JS
      import * as pagefind from "pagefind";

      const searchData = #{json};
      const outputPath = #{OUTPUT_PATH.to_s.to_json};

      const { index } = await pagefind.createIndex({ forceLanguage: "en" });

      for (const item of Object.values(searchData)) {
        const { errors } = await index.addCustomRecord({
          url: item.url,
          content: item.content,
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
    print output
    raise "Pagefind build failed" unless status.success?

    File.write(HASH_FILE, hash)
  end

  private

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
