module Sidekiq1
  module Failures
    Superclass =
      if defined?(Sidekiq1::JobSet)
        Sidekiq1::JobSet
      else
        Sidekiq1::SortedSet
      end

    class FailureSet < Superclass
      def initialize
        super LIST_KEY
      end

      def retry_all_failures
        while size > 0
          each(&:retry_failure)
        end
      end
    end
  end
end
