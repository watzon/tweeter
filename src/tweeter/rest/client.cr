require "../client"
require "./api"
require "./request"
require "./utils"

module Tweeter::REST
  class Client < Tweeter::Client
    include Tweeter::REST::API

    getter bearer_token : String?

    def bearer_token?
      !!bearer_token
    end

    def credentials?
      super || bearer_token?
    end
  end
end
