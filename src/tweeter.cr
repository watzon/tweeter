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
  config.consumer_key = "KkZGlVZuCB7psYIP1jR2xxIN6"
  config.consumer_secret = "aylQJALc6LomibnywQUNmR4gJs7oZ7MrvyulS11egoXL3nRgFe"
  config.access_token = "2252786816-rAtE0f5Ud0JAoIvmXIpS4TdZSfvbLRIUGuw470G"
  config.access_token_secret = "i0Qty9xNjtrO0tRhYa0buLgomTYQlenxAMkRDruX3EIM5"
end

p client.create_direct_message(2252786816_i64, "Hello")
