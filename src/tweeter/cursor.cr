require "./base"
require "./client"
require "./enumerable"

module Tweeter
  class Cursor(T)
    include Tweeter::Enumerable(T)

    @key : String
    @client : Tweeter::Client
    @request_method : String
    @path : String
    @options : Hash(String, JSON::Any)
    @collection : Array(T)
    @attrs : Hash(String, JSON::Type)

    getter attrs

    alias_method :to_h, :attrs

    def initialize(key, @klass : T.class, request)
      @key = key.to_s
      @client = request.client
      @request_method = request.verb
      @path = request.path
      @options = Hash(String, JSON::Any).from_json(request.options.to_json)
      @collection = [] of T
      @attrs = {} of String => JSON::Type

      self.attrs = request.perform.as_h
    end

    private def next_cursor
      @attrs["next_cursor"].as(Int64) || -1
    end

    private def last?
      next_cursor.zero?
    end

    private def fetch_next_page
      request = Tweeter::REST::Request.new(@client, @request_method, @path, @options.merge({"cursor" => next_cursor}))
      self.attrs = request.perform.as_h
    end

    private def attrs=(attrs)
      @attrs = attrs
      @attrs.fetch(@key, [] of JSON::Type).as(Array(JSON::Type)).each do |element|
        @collection << @klass.new(element.as(Int64))
      end
      @attrs
    end
  end
end
