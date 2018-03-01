require "../place"
require "./request"
require "./utils"
require "../trend_results"

module Tweeter::REST::Trends
  include Tweeter::REST::Utils

  def trends(id = 1, options = nil)
    options = normalize_options(options)
    options["id"] = id.to_s
    response = get("/1.1/trends/place.json", options, Array(Tweeter::TrendResults))
    response.first
  end

  alias_method :local_trends, :trends
  alias_method :trends_place, :trends

  def trends_available(options = nil)
    get("/1.1/trends/available.json", normalize_options(options), Array(Tweeter::Place))
  end

  alias_method :trend_locations, :trends_available

  def trends_closest(lat : Float64, long : Float64, options = nil)
    options = normalize_options(options).merge({"lat" => lat.to_s, "long" => long.to_s})
    get("/1.1/trends/closest.json", options, Array(Tweeter::Place))
  end
end
