require "halite"
require "../headers"
require "./utils"

module Tweeter::REST
  module OAuth
    extend self
    include Tweeter::REST::Utils

    def token(options = {} of String => String)
      options = options.dup
      options["bearer_token_request"] = "true"
      options["grant_type"] ||= "client_credentials"
      url = "https://api.twitter.com/oauth2/token"
      headers = Tweeter::Headers.new(self, "post", url, options).request_headers
      response = Halite.headers(headers).post(url, form: options)
      response.parse["access_token"].as_s
    end

    def invalidate_token(access_token, options = {} of String => String)
      options = options.dup
      options["access_token"] = access_token
      post("/oauth2/invalidate_token", options)["access_token"]
    end

    def reverse_token
      options = {"x_auth_mode" => "reverse_auth"}
      url = "https://api.twitter.com/oauth/request_token"
      auth_header = Tweeter::Headers.new(self, "post", url, options).oauth_auth_header.to_s
      Halite.header(authorization: auth_header).post(url, params: options).to_s
    end
  end
end
