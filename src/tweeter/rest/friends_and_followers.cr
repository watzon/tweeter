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
        get("/1.1/friends/ids.json", arguments.options, :ids, Int64)
      end

      def follower_ids(*args)
        arguments = Tweeter::Arguments(UserArgs).new(args)
        merge_user!(arguments.options, arguments.pop)
        get("/1.1/followers/ids.json", arguments.options, :ids, Int64)
      end

      def friendships(*args)
        arguments = Tweeter::Arguments(UserArgs).new(args)
        merge_users!(arguments.options, arguments)
        get("/1.1/friendships/lookup.json", arguments.options, Array(Tweeter::User))
      end

      def friendships_incoming(options = {} of String => String)
        get("/1.1/friendships/incoming.json", options, :ids, Int64)
      end

      def friendships_outgoing(options = {} of String => String)
        get("/1.1/friendships/outgoing.json", options, :ids, Int64)
      end

      def follow(*args)
        arguments = Tweeter::Arguments(UserArgs).new(args)
        existing_friends = friend_ids(*args).to_a
        new_friends = users(*args).map(&.id.to_i64.abs)
        follow!(new_friends - existing_friends, arguments.options)
      end

      alias_method :create_friendship, :follow

      def follow!(*args)
        arguments = Tweeter::Arguments(UserArgs).new(args)
        arguments.map do |user|
          post("/1.1/friendships/create.json", merge_user(arguments.options, user), Tweeter::User)
        end.compact
      end

      alias_method :create_friendship!, :follow!

      def unfollow(*args)
        arguments = Tweeter::Arguments(UserArgs).new(args)
        arguments.map do |user|
          post("/1.1/friendships/destroy.json", merge_user(arguments.options, user), Tweeter::User)
        end
      end

      def friendship_update(user, options = {} of String => String)
        merge_user!(options, user)
        post("/1.1/friendships/update.json", options, Tweeter::Relationship)
      end

      def friendship(source, target, options = {} of String => String)
        options = options.dup
        merge_user!(options, source, "source")
        options["source_id"] = options.delete("source_user_id").not_nil! if options.has_key?("source_user_id")
        merge_user!(options, target, "target")
        options["target_id"] = options.delete("target_user_id").not_nil! if options.has_key?("target_user_id")
        get("/1.1/friendships/show.json", options, Tweeter::Relationship)
      end
    end
  end
end
