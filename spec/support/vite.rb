# frozen_string_literal: true
require Rails.root.join("config/flock")

# https://mattbrictson.com/blog/faster-vite-test-without-autobuild
Flock.with_lock("vite-build", timeout: 30) do
  ViteRuby.commands.build
end
