$TESTING = true

require "minitest/autorun"
require "minitest/spec"
require "minitest/mock"

require "rack/test"

require "sidekiq"
require "sidekiq1-failures"
require "sidekiq1/processor"
require "sidekiq1/fetch"
require "sidekiq1/cli"

Sidekiq1logger.level = Logger::ERROR

REDIS = Sidekiq1::RedisConnection.create(url: "redis://localhost/15")
