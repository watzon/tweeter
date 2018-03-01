require "./base"

module Tweeter
  class Coordinates < Tweeter::Base
    create_initializer({
      coordinates: {type: Array(Float64), default: [] of Float64},
    })

    def from_json(value : JSON::PullParser) : Point | Polygon
      str = value.read_string
      if value =~ /"type":\s?"point"/
        Point.from_json(str)
      else
        Polygon.from_json(str)
      end
    end

    class Point < Tweeter::Coordinates
      delegate :from_json, to: Object

      create_initializer({
        type: {type: String, mustbe: "point"},
      })

      def latitude
        coordinates[0]
      end

      def longitude
        coordinates[1]
      end
    end

    class Polygon < Tweeter::Coordinates
      delegate :from_json, to: Object

      create_initializer({
        type: {type: String, mustbe: "polygon"},
      })
    end
  end
end
