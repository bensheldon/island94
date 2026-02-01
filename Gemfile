# frozen_string_literal: true
source "https://rubygems.org"
ruby File.read(File.join(File.dirname(__FILE__), ".ruby-version")).strip

gem "activesupport"
gem "csv"
gem "jekyll" # still necessary for bookmarking scripts
gem "octokit"

gem "parklife"
gem "parklife-rails"
gem "rails", "~> 8.1.1"

gem "bootsnap", require: false
gem "bootstrap"
gem "front_matter_parser"
gem "importmap-rails"
gem "kramdown-parser-gfm"
gem "metainspector", "~> 5.17" # for fetching bookmarks
gem "puma"
gem "rake"
gem "rouge"
gem "sassc-rails"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails", "~> 2.0"
gem "vernier"

group :development, :test do
  gem "capybara"
  gem "cuprite"
  gem "erb_lint", require: false
  gem "rspec-rails"
  gem "rubocop-capybara", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", require: false
end
