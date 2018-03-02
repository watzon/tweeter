require "./request"
require "../search_results"
require "./utils"

module Tweeter::REST::Search
  include Tweeter::REST::Utils

  MAX_TWEETS_PER_REQUEST = 100

  def search(q, options = nil)
    options = normalize_options(options).merge({"q" => q})
    options["count"] ||= MAX_TWEETS_PER_REQUEST.to_s
    response = Tweeter::REST::Request.new(self, :get, "/1.1/search/tweets.json", options).perform
    Tweeter::SearchResults.from_json(response.to_json)
  end
end
