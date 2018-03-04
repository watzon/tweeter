require "uri"
require "json"
require "file"

require "./core_ext/**"
require "./tweeter/configuration"
require "./tweeter/cursor"
require "./tweeter/direct_message"
require "./tweeter/entities"
require "./tweeter/coordinates"
require "./tweeter/language"
require "./tweeter/list"
require "./tweeter/media_factory"
require "./tweeter/metadata"
require "./tweeter/oembed"
require "./tweeter/place"
require "./tweeter/profile_banner"
require "./tweeter/rate_limit"
require "./tweeter/relationship"
require "./tweeter/rest/client"
require "./tweeter/saved_search"
require "./tweeter/search_results"
require "./tweeter/settings"
require "./tweeter/size"
require "./tweeter/source_user"
require "./tweeter/streaming/client"
require "./tweeter/suggestion"
require "./tweeter/target_user"
require "./tweeter/trend"
require "./tweeter/tweet"
require "./tweeter/user"

# TODO: Write documentation for `Tweeter`
module Tweeter
  # TODO: Put your code here
end

client = Tweeter::REST::Client.new do |config|
  config.consumer_key        = "NUkIxxzC80q0tjhX9zSC5N0x1"
  config.consumer_secret     = "AxNoHDqG1yOje7Q2s13PM2q28yaZNbGkB0zGhWqsjCLvPSstrZ"
  config.access_token        = "2252786816-W6EpFY930xp5w9DAeq9yFCzEp0SWMMKL6doOix8"
  config.access_token_secret = "mhsMdrZlA0lp4Fn5xNGA10Wyyjh1jwBcZKWzR8lcdk3pe"
end

memberships = client.memberships.to_a
p client.list_subscribers(memberships[1]).size
