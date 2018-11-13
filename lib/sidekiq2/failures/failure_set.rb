module Sidekiq2
  module Failures
    Superclass =
      if defined?(Sidekiq2::JobSet)
        Sidekiq2::JobSet
      else
        Sidekiq2::SortedSet
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
