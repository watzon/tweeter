require "./base"

module Tweeter
  class RateLimit
    @limit : Int32?
    @remaining : Int32?
    @reset_at : Int32?

    def initialize(**headers)
      @limit = headers[:limit]?
      @remaining = headers[:remaining]?
      @reset_at = headers[:reset]?
    end

    def initialize(headers = {} of String => String)
      headers = headers.transform_values { |v| v.is_a?(Array) ? v.first : v }
      @limit = headers["x-rate-limit"]? ? headers["x-rate-limit"].to_i : nil
      @remaining = headers["x-rate-limit-remaining"]? ? headers["x-rate-limit-remaining"].to_i : nil
      @reset_at = headers["x-rate-limit-reset"]? ? headers["x-rate-limit-reset"].to_i : nil
    end

    def limit
      if limit = @limit
        limit.to_i
      end
    end

    def remaining
      if remaining = @remaining
        remaining.to_i
      end
    end

    def reset_at
      if reset = @reset_at
        Time.epoch(reset.to_i) unless reset.nil?
      end
    end

    def reset_in
      if reset = reset_at
        [(reset.epoch - Time.now.epoch).ceil, 0].max
      end
    end
  end
end
