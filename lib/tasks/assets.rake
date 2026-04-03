# frozen_string_literal: true
Rake::Task["assets:precompile"].enhance do
  require Rails.root.join("config/pagefind")
  Pagefind.build
end
