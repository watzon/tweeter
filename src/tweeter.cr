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
  config.access_token = "2252786816-GCsP8yHLzs2DhwDz4AHHSAXloSY5iD4uhoZjAK5"
  config.access_token_secret = "XER7jm3FTFVKNgqpfGW2m4uRjYDOfli4qf4Ec8XcAsCet"
end

p client.search("to:justinbieber marry me", {result_type: "recent"}).take(3).map { |tweet| "#{tweet.user.not_nil!.screen_name}: #{tweet.text}" }
