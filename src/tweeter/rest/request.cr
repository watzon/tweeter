require "uri"
require "oauth"
require "halite"

require "../error"
require "../client"
require "../headers"
require "../rate_limit"

module Tweeter::REST
  class Request
    BASE_URL = "https://api.twitter.com"

    getter :client, :headers, :options, :path, :rate_limit,
      :request_method, :uri

    alias_method :verb, :request_method

    @uri : URI
    @path : String
    @request_method : String
    @client : Tweeter::Client
    @options : Hash(String, String)
    @headers : Hash(String, String) = {} of String => String

    def initialize(
      client : Tweeter::Client,
      request_method : String,
      path : String,
      options = nil
    )
      @options = options ? options.transform_values(&.to_s) : {} of String => String
      @client = client
      @uri = URI.parse(path.starts_with?("http") ? path : BASE_URL + path)
      @path = @uri.path.not_nil!
      @request_method = request_method

      set_multipart_options!(request_method, @options)
    end

    def perform
      options_key = @request_method == "get" ? "params" : "form"
      options = @options.transform_values(&.as(String))
      response = http_client.headers(@headers).request(@request_method, @uri.to_s, {options_key => options})
      response_body = response.body.empty? ? nil : response.parse
      response_headers = response.headers
      fail_or_return_response_body(response.status_code, response_body, response_headers)
    end

    private def merge_multipart_file!(options)
      # key = options.delete("key")
      # file = options.delete("file")

      # @options[key] =
      #   if file.is_a?(File)
      #     file
      #   else
      #     File.open(file.as(String))
      #   end.as(JSON::Any)
    end

    private def set_multipart_options!(request_method, options)
      if request_method == "multipart_post"
        merge_multipart_file!(options)
        @request_method = "post"
        @headers = Tweeter::Headers.new(@client, @request_method, @uri).request_headers
      else
        @headers = Tweeter::Headers.new(@client, @request_method, @uri, options).request_headers
      end
    end

    private def mime_type(basename)
      case basename
      when /\.gif$/i
        "image/gif"
      when /\.jpe?g/i
        "image/jpeg"
      when /\.png/i
        "image/png"
      else
        "application/octet-stream"
      end
    end

    private def fail_or_return_response_body(code, body, headers)
      error = error(code, body, headers)
      raise(error) unless error.nil?
      @rate_limit = Tweeter::RateLimit.new(headers.to_h)
      body.not_nil!
    end

    private def error(code, body, headers)
      klass = Tweeter::Error::ERRORS[code]?
      if klass == Tweeter::Error::Forbidden
        forbidden_error(body, headers)
      elsif !klass.nil?
        klass.from_response(body, headers)
      end
    end

    private def forbidden_error(body, headers)
      error = Tweeter::Error::Forbidden.from_response(body, headers)
      klass = Tweeter::Error::FORBIDDEN_MESSAGES[error.message]
      if klass
        klass.from_response(body, headers)
      else
        error
      end
    end

    private def http_client
      connect_timeout = @client.timeouts["connect"]?
      read_timeout = @client.timeouts["read"]?
      Halite.timeout(connect: connect_timeout, read: read_timeout)
    end
  end
end
