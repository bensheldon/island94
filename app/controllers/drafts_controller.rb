# frozen_string_literal: true

# Lists unpublished posts and bookmarks. Routed only in local environments.
class DraftsController < ApplicationController
  layout "narrow"

  def index
    @posts = Post.all.reject(&:published?).sort_by(&:published_at).reverse
    @bookmarks = Bookmark.all.reject(&:published?).sort_by(&:date).reverse
  end
end
