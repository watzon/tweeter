module Tweeter
  class Arguments(T) < Array(T)
    getter options : Hash(String, String)

    def initialize(args = [] of String)
      args = args.to_a.flatten
      super(args.size)

      @options = !args.empty? && (args.last.is_a?(::Hash) || args.last.is_a?(NamedTuple)) ?
        args.pop.to_h.transform_keys(&.to_s).transform_values(&.to_s) :
        {} of String => String

      args.each { |a| a.is_a?(T) ? push(a) : nil }
    end
  end
end
