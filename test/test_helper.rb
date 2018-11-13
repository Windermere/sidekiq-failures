$TESTING = true

require "minitest/autorun"
require "minitest/spec"
require "minitest/mock"

require "rack/test"

require "sidekiq"
require "sidekiq2-failures"
require "sidekiq2/processor"
require "sidekiq2/fetch"
require "sidekiq2/cli"

Sidekiq2.logger.level = Logger::ERROR

REDIS = Sidekiq2::RedisConnection.create(url: "redis://localhost/15")
