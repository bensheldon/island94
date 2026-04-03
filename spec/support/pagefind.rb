# frozen_string_literal: true
require Rails.root.join("config/flock")
require Rails.root.join("config/pagefind")

Flock.with_lock("pagefind-build", timeout: 30) do
  Pagefind.build
end
