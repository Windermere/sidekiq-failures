require "test_helper"

module Sidekiq2
  describe Failures do
    describe '.retry_middleware_class' do
      it 'returns based on Sidekiq2::VERISON' do
        case Sidekiq2::VERSION[0]
        when '5'
          assert_equal Failures.retry_middleware_class, Sidekiq2::JobRetry
        when '4'
          assert_equal Failures.retry_middleware_class, Sidekiq2::Middleware::Server::RetryJobs
        end
      end
    end
  end
end
