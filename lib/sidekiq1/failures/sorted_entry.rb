module Sidekiq1
  class SortedEntry
    alias_method :super_initialize, :initialize

    def initialize(parent, score, item)
      super_initialize(parent, score, item)

      # 0.3.0 compatibility
      @item.merge!(@item["payload"]) if @item["payload"]
    end

    def retry_failure
      Sidekiq1redis do |conn|
        results = conn.zrangebyscore(Sidekiq1::Failures::LIST_KEY, score, score)
        conn.zremrangebyscore(Sidekiq1::Failures::LIST_KEY, score, score)
        results.map do |message|
          msg = Sidekiq1load_json(message)
          Sidekiq1::Client.push(msg)
        end
      end
    end
  end
end
