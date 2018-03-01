require "../arguments"
require "../cursor"
require "./utils"
require "../tweet"
require "../user"

module Tweeter::REST::Undocumented
  include Tweeter::REST::Utils

  def status_summary(tweet, options = nil)
    get("/1.1/statuses/#{extract_id(tweet)}/activity/summary.json", normalize_options(options), Array(Tweeter::User))
  end

  def conversation(tweet, options = nil)
    options = normalize_options(options).merge({"id" => extract_id(tweet)})
    get("/1.1/conversation/show.json", options, Array(Tweeter::Tweet))
  end

  def following_followers_of(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    merge_user!(arguments.options, arguments.pop { user_id }) unless arguments.options["user_id"]? || arguments.options["screen_name"]?
    get("/1.1/users/following_followers_of.json", arguments.options, "users", Tweeter::User)
  end

  def by_friends(options = nil)
    get("/1.1/activity/by_friends.json", normalize_options(options), Array(JSON::Any))
  end

  def translation(tweet, language = "en")
    options = {"dest" => language, "id" => extract_id(tweet)}
    get("/1.1/translations/show.json", normalize_options(options), Tweeter::Tweet)
  end
end
