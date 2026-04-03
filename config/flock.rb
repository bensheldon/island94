# frozen_string_literal: true
module Flock
  DEFAULT_DIR = Rails.root.join('tmp').freeze
  LockTimeout = Class.new(StandardError)
  SLEEP_INTERVAL = 0.01

  # Takes a file-based lock; the lockfile will not be removed afterwards.
  def self.with_lock(lockname, timeout: 10)
    FileUtils.mkdir_p(DEFAULT_DIR)

    lockfile = File.join(DEFAULT_DIR, "#{lockname}.lock")
    File.open(lockfile, File::CREAT) do |file|
      deadline = Time.zone.now + timeout
      # Attempt non-blocking lock; returns false if already locked, 0 if not
      until file.flock(File::LOCK_EX | File::LOCK_NB)
        raise LockTimeout, "Could not obtain lock in #{timeout}s" if Time.zone.now >= deadline

        sleep SLEEP_INTERVAL
      end

      yield
    end
  end
end
