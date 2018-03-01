require "uri"
require "base64"
require "oauth"
require "easy_oauth"

require "./rest/client"

module Tweeter
  class Headers
    @client : Tweeter::REST::Client
    @request_method : String
    @uri : URI
    @bearer_token_request : Bool?
    @options : Hash(String, String)

    def initialize(client, request_method, url, options = {} of String => String)
      @client = client.as(Tweeter::REST::Client)
      @request_method = request_method
      @uri = url.is_a?(URI) ? url : URI.parse(url)
      @bearer_token_request = options["bearer_token_request"]? ? options.delete("bearer_token_request") == "true" : false
      @options = options
    end

    def bearer_token_request?
      !!@bearer_token_request
    end

    def oauth_auth_header
      options = @options.transform_values(&.as(String))
      credentials = @client.credentials.merge({"ignore_extra_keys" => true})
                                       .transform_values(&.to_s)
      EasyOAuth::Header.new(@request_method, @uri, options, credentials)
    end

    def request_headers
      headers = {} of String => String
      headers["user_agent"] = @client.user_agent
      if bearer_token_request?
        headers["accept"] = "*/*"
        headers["authorization"] = bearer_token_credentials_auth_header
      else
        headers["authorization"] = auth_header
      end
      headers
    end

    private def auth_header
      if @client.user_token?
        oauth_auth_header.to_s
      else
        @client.bearer_token = @client.token unless @client.bearer_token?
        bearer_auth_header
      end
    end

    private def bearer_auth_header
      "Bearer #{@client.bearer_token}"
    end

    private def bearer_token_credentials_auth_header
      encoded = Base64.strict_encode("#{@client.consumer_key}:#{@client.consumer_secret}")
      "Basic #{encoded}"
    end
  end
end
