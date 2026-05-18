# frozen_string_literal: true
class PostsController < ApplicationController
  LIMIT = 10

  layout "narrow"

  def index
    @limit = LIMIT
    @page = params.fetch(:page, 1).to_i
    @posts = Post.all.reverse.drop((@page - 1) * @limit).take(@limit)
  end

  def show
    # remove any trailing extension
    slug_param = params.expect(:slug).sub(/\.[^.]*\z/, "")

    @post = Post.all.find { |post| post.slug == slug_param }
    raise ActionController::RoutingError, "Not Found" unless @post
  end

  def tag
    tag_slug = params[:tag_slug]
    @tag = Post.tags.find { |tag| tag.parameterize == tag_slug }
    raise ActionController::RoutingError, "Not Found" unless @tag

    @posts = Post.all.select { |post| post.tags.include?(@tag) }
  end
end
