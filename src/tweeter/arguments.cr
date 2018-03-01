require "json"

module Tweeter
  class Arguments(T) < Array(T)
    getter options : Hash(String, String)

    def initialize(args = [] of String)
      args = args.to_a.flatten
      super(args.size)
      @options = !args.empty? && args.last.is_a?(::Hash) ? args.pop.as(Hash(String, String)) : {} of String => String
      args.each { |a| push(a.as(T)) }
    end
  end
end
