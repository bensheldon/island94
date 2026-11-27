# frozen_string_literal: true
Rails.application.routes.draw do
  root "posts#index"

  get "/posts/:page", to: "posts#index", constraints: { page: /\d+/ }, as: :posts
  get "/:year/:month/:slug", to: "posts#show", as: :slugged_post, constraints: { year: /\d*/, month: /\d{2}/, slug: /.*/, format: /html/ }
  direct :post do |post, options|
    route_for :slugged_post, { year: post.published_at.strftime('%Y'), month: post.published_at.strftime('%m'), slug: post.slug }.merge(options)
  end

  get "about", to: "pages#about"
  get "archives", to: "pages#archives"
  get "books", to: "pages#books"

  get "tags", to: "pages#tags"
  get "posts/tags/:tag_slug", to: "posts#tag", as: :_tag
  direct :tag do |tag, options|
    route_for :_tag, { tag_slug: tag.parameterize }.merge(options)
  end

  get "search", to: "pages#search", format: :html
  get "search", to: "pages#search", format: :json

  get "feed", to: "pages#feed", as: :feed, format: :xml

  get "redirects", to: "redirects#index"

  resources :bookmarks, only: [:index]
  get "/bookmarks/:year/:month/:slug", to: "bookmarks#show", as: :slugged_bookmark, constraints: { year: /\d*/, month: /\d{2}/, slug: /.*/, format: /html/ }
  direct :bookmark do |bookmark, options|
    route_for :slugged_bookmark, { year: bookmark.date.strftime('%Y'), month: bookmark.date.strftime('%m'), slug: bookmark.slug }.merge(options)
  end

  get 'robots', to: 'robots#robots', as: :robots, format: :txt, defaults: { format: :txt }
  get 'sitemap', to: 'robots#sitemap', as: :sitemap, format: :xml, defaults: { format: :xml }

  # Unpublished posts and bookmarks. Local only, never part of the published site.
  get "drafts", to: "drafts#index" if Rails.env.local?

  mount Editor::Engine, at: "/editor" if defined?(Editor::Engine)

  get "*path", to: redirect { |_params, request| Redirect.path(request.fullpath) }, constraints: ->(req) { Redirect.path?(req.fullpath) }
end
