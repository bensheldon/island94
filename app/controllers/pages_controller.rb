# frozen_string_literal: true
class PagesController < ApplicationController
  layout(lambda do
    if action_name == 'feed'
      nil
    else
      "narrow"
    end
  end)

  def about
  end

  def archives
    @posts = Post.all.reverse
  end

  def books
  end

  def tags
    @posts = Post.all
  end

  def feed
    @posts = Post.all.reverse.take(10)
  end

  before_action :build_search_index, only: :search

  def search
    respond_to do |format|
      format.html
      format.json
    end
  end

  private

  def build_search_index
    Pagefind.build
  end
end
