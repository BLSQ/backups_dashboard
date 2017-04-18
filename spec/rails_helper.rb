require "sidekiq/testing"
require "rspec-sidekiq"

RSpec::Sidekiq.configure do |config|
  # Clears all job queues before each example
  config.clear_all_enqueued_jobs = true # default => true

  # Whether to use terminal colours when outputting messages
  config.enable_terminal_colours = true # default => true

  # Warn when jobs are not enqueued to Redis but to a job array
  config.warn_when_jobs_not_processed_by_sidekiq = true # default => true
end
module RSpec
  module Sidekiq
    module Matchers
      # fix conflict with active job have_enqueued_job from rspec-rails
      alias have_enqueued_sidekiq_job have_enqueued_job
    end
  end
end
