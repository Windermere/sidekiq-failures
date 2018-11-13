module Sidekiq2
  class SortedEntry
    alias_method :super_initialize, :initialize

    def initialize(parent, score, item)
      super_initialize(parent, score, item)

      # 0.3.0 compatibility
      @item.merge!(@item["payload"]) if @item["payload"]
    end

    def retry_failure
      Sidekiq2.redis do |conn|
        results = conn.zrangebyscore(Sidekiq2::Failures::LIST_KEY, score, score)
        conn.zremrangebyscore(Sidekiq2::Failures::LIST_KEY, score, score)
        results.map do |message|
          msg = Sidekiq2.load_json(message)
          Sidekiq2::Client.push(msg)
        end
      end
    end
  end
end
