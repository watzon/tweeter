require "http/client"
require "oauth"

require "./version"
require "./error"

module Tweeter
  class Client
    API_URL = "api.twitter.com"

    @token : String?
    @access_token : String?
    @access_token_secret : String?
    @consumer_key : String?
    @consumer_secret : String?
    @proxy : String?
    @timeouts : Hash(String, Int32)

    property :access_token, :access_token_secret, :bearer_token,
      :consumer_key, :consumer_secret, :proxy, :timeouts
    setter :user_agent

    def initialize(**options)
      @access_token = options["access_token"]?
      @access_token_secret = options["access_token_secret"]?
      @consumer_key = options["consumer_key"]?
      @consumer_secret = options["consumer_secret"]?
      @proxy = options["proxy"]?
      @timeouts = options["timeouts"]? || {} of String => Int32
    end

    def self.new(&block)
      client = new
      yield client
      client
    end

    # @return [Boolean]
    def user_token?
      !(blank?(access_token) || blank?(access_token_secret))
    end

    # @return [String]
    def user_agent
      @user_agent ||= "Tweeter.cr/#{Tweeter::Version.to_s}"
    end

    # @return [Hash]
    def credentials
      {
        "consumer_key"    => @consumer_key,
        "consumer_secret" => @consumer_secret,
        "token"           => @access_token,
        "token_secret"    => @access_token_secret,
      }
    end

    # @return [Boolean]
    def credentials?
      credentials.values.none? { |v| blank?(v) }
    end

    private def blank?(s)
      s.responds_to?(:empty?) ? s.empty? : !s
    end
  end
end
