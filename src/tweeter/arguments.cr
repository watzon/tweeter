module Tweeter
  class Arguments(T) < Array(T)
    getter options : Hash(String, String)

    def initialize(args = [] of String)
      args = args.to_a.flatten
      super(args.size)

      @options = if !args.empty? && args.last.is_a?(::Hash)
                   args.pop.as(Hash(String, String))
                 elsif !args.empty? && args.last.is_a?(::NamedTuple)
                   args.pop.as(NamedTuple).to_h.transform_keys(&.to_s).transform_values(&.to_s)
                 else
                   {} of String => String
                 end

      args.each { |a| a.is_a?(T) ? push(a) : nil }
    end
  end
end
