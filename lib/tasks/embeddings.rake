# frozen_string_literal: true

namespace :embeddings do
  desc "Generate semantic embeddings for new/changed posts and bookmarks"
  task update: :environment do
    count = Embeddings.update!(Post.published + Bookmark.published)
    $stdout.puts "Embedded #{count} document(s)"
  end
end
