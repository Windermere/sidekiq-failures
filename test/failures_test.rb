require "test_helper"

module Sidekiq1
  describe Failures do
    describe '.retry_middleware_class' do
      it 'returns based on Sidekiq1::VERISON' do
        case Sidekiq1::VERSION[0]
        when '5'
          assert_equal Failures.retry_middleware_class, Sidekiq1::JobRetry
        when '4'
          assert_equal Failures.retry_middleware_class, Sidekiq1::Middleware::Server::RetryJobs
        end
      end
    end
  end
end
