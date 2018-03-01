require "./direct_messages"
require "./favorites"
require "./friends_and_followers"
require "./help"
require "./lists"
require "./oauth"
require "./places_and_geo"
require "./saved_searches"
require "./search"
require "./spam_reporting"
require "./suggested_users"
require "./timelines"
require "./trends"
require "./tweets"
require "./undocumented"
require "./users"

module Tweeter::REST::API
  include Tweeter::REST::OAuth
  include Tweeter::REST::Users
  include Tweeter::REST::FriendsAndFollowers
end
