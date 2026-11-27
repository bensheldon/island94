# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Drafts" do
  describe "GET /drafts" do
    it "lists unpublished posts and bookmarks, not published ones" do
      allow(Post).to receive(:all).and_return([
                                                Post.new(filepath: "#{Rails.root}/_posts/2024-01-01-draft.md", frontmatter: { "title" => "Draft Post", "published" => false }, body: "Hi"),
                                                Post.new(filepath: "#{Rails.root}/_posts/2024-01-02-live.md", frontmatter: { "title" => "Live Post" }, body: "Hi"),
                                              ])
      allow(Bookmark).to receive(:all).and_return([
                                                    Bookmark.new(filepath: "#{Rails.root}/_bookmarks/2024/2024-01-01-draft.md", frontmatter: { "link" => "https://example.com/draft", "title" => "Draft Bookmark", "date" => "2024-01-01 10:00 UTC", "published" => false }),
                                                    Bookmark.new(filepath: "#{Rails.root}/_bookmarks/2024/2024-01-02-live.md", frontmatter: { "link" => "https://example.com/live", "title" => "Live Bookmark", "date" => "2024-01-02 10:00 UTC" }),
                                                  ])

      get "/drafts"

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Draft Post", "Draft Bookmark")
      expect(response.body).not_to include("Live Post", "Live Bookmark")
    end
  end
end
