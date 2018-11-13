begin
  require "sidekiq1/web"
rescue LoadError
  # client-only usage
end

require "sidekiq1/api"
require "sidekiq1/version"
require "sidekiq1/failures/version"
require "sidekiq1/failures/sorted_entry"
require "sidekiq1/failures/failure_set"
require "sidekiq1/failures/middleware"
require "sidekiq1/failures/web_extension"

module Sidekiq1

  SIDEKIQ1_FAILURES_MODES = [:all, :exhausted, :off].freeze

  # Sets the default failure tracking mode.
  #
  # The value provided here will be the default behavior but can be overwritten
  # per worker by using `sidekiq_options :failures => :mode`
  #
  # Defaults to :all
  def self.failures_default_mode=(mode)
    unless SIDEKIQ1_FAILURES_MODES.include?(mode.to_sym)
      raise ArgumentError, "Sidekiq#failures_default_mode valid options: #{SIDEKIQ1_FAILURES_MODES}"
    end

    @failures_default_mode = mode.to_sym
  end

  # Fetches the default failure tracking mode.
  def self.failures_default_mode
    @failures_default_mode || :all
  end

  # Sets the maximum number of failures to track
  #
  # If the number of failures exceeds this number the list will be trimmed (oldest
  # failures will be purged).
  #
  # Defaults to 1000
  # Set to false to disable rotation
  def self.failures_max_count=(value)
    @failures_max_count = value
  end

  # Fetches the failures max count value
  def self.failures_max_count
    if !instance_variable_defined?(:@failures_max_count) || @failures_max_count.nil?
      1000
    else
      @failures_max_count
    end
  end

  module Failures
    LIST_KEY = :failed

    def self.reset_failures
      Sidekiq1redis { |c| c.set("stat:failed", 0) }
    end

    def self.count
      Sidekiq1redis {|r| r.zcard(LIST_KEY) }
    end

    def self.retry_middleware_class
      if Gem::Version.new(Sidekiq1::VERSION) >= Gem::Version.new('5.0.0')
        require 'sidekiq1/job_retry'
        Sidekiq1::JobRetry
      else
        require 'sidekiq1/middleware/server/retry_jobs'
        Sidekiq1::Middleware::Server::RetryJobs
      end
    end

  end
end

Sidekiq1.configure_server do |config|
  config.server_middleware do |chain|
    chain.insert_before Sidekiq1::Failures.retry_middleware_class,
                        Sidekiq1::Failures::Middleware
  end
end

if defined?(Sidekiq1::Web)
  Sidekiq1::Web.register Sidekiq1::Failures::WebExtension
  Sidekiq1::Web.tabs["Failures"] = "failures"
  Sidekiq1::Web.settings.locales << File.join(File.dirname(__FILE__), "failures/locales")
end
