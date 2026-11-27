# frozen_string_literal: true
class BookmarksController < ApplicationController
  def index
    @bookmarks = Bookmark.published.sort_by(&:date).reverse
  end

  def show
    slug_param = params.expect(:slug).sub(/\.[^.]*\z/, "").downcase
    year_month = "#{params.expect(:year)}-#{params.expect(:month)}"
    @bookmark = Bookmark.all.find do |bookmark|
      bookmark.slug.downcase == slug_param && bookmark.date.strftime("%Y-%m") == year_month
    end
    raise ActionController::RoutingError, "Not Found" unless @bookmark
  end
end
