require "../arguments"
require "../cursor"
require "../relationship"
require "./request"
require "./utils"
require "../user"
require "../utils"

module Tweeter
  module REST
    module FriendsAndFollowers
      include Tweeter::REST::Utils
      include Tweeter::Utils

      def friend_ids(*args)
        arguments = Tweeter::Arguments(UserArgs).new(args)
        merge_user!(arguments.options, arguments.pop)
        get("/1.1/friends/ids.json", arguments.options, "ids", Tweeter::User)
      end

      def follower_ids(*args)
        arguments = Tweeter::Arguments(UserArgs).new(args)
        merge_user!(arguments.options, arguments.pop)
        get("/1.1/followers/ids.json", arguments.options, "ids", Tweeter::User)
      end
    end
  end
end
