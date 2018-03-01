require "./utils"
require "../arguments"
require "../user"
require "../tweet"

module Tweeter::REST::Timelines
  include Tweeter::REST::Utils

  DEFAULT_TWEETS_PER_REQUEST =  20
  MAX_TWEETS_PER_REQUEST     = 200

  def mentions_timeline(options = nil)
    get("/1.1/statuses/mentions_timeline.json", normalize_options(options), Array(Tweeter::Tweet))
  end

  alias_method :mentions, :mentions_timeline

  def user_timeline(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    merge_user!(arguments.options, arguments.pop)
    get("/1.1/statuses/user_timeline.json", arguments.options, Array(Tweeter::Tweet))
  end

  def retweeted_by_user(user, options = nil)
    retweets_from_timeline(options) do |opts|
      user_timeline(user, opts)
    end
  end

  alias_method :retweeted_by, :retweeted_by_user

  def retweeted_by_me(options = nil)
    retweets_from_timeline(options) do |opts|
      user_timeline(opts)
    end
  end

  def home_timeline(options = nil)
    get("/1.1/statuses/home_timeline.json", normalize_options(options), Array(Tweeter::Tweet))
  end

  def retweeted_to_me(options = nil)
    retweets_from_timeline(options) do |opts|
      home_timeline(opts)
    end
  end

  def retweete_of_me(options = nil)
    get("/1.1/statuses/retweets_of_me.json", normalize_options(options), Array(Tweeter::Tweet))
  end

  private def retweets_from_timeline(options, &block)
    options = normalize_options(options)
    options["include_rts"] = "true"
    count = options["count"]? || DEFAULT_TWEETS_PER_REQUEST.to_s
    select_retweets(yield(options))
  end

  private def select_retweets(tweets)
    tweets.select(&.retweet?)
  end
end
