require "../arguments"
require "../error"
require "../oembed"
require "./request"
require "./utils"
require "../tweet"
require "../utils"

module Tweeter::REST::Tweets
  include Tweeter::REST::Utils
  include Tweeter::Utils

  MAX_TWEETS_PER_REQUEST = 100

  def retweets(tweet, options = nil)
    get("/1.1/statuses/retweets/#{extract_id(tweet)}.json", normalize_options(options), Array(Tweeter::Tweet))
  end

  def retweeters_of(tweet, options = nil)
    options = normalize_options(options)
    ids_only = !!options.delete("ids_only")
    retweeters = retweets(tweet, options).map(&.user).compact
    ids_only ? retweeters.map(&.id).compact : retweeters
  end

  def status(tweet, options = nil)
    get("/1.1/statuses/show/#{extract_id(tweet)}.json", normalize_options(options), Tweeter::Tweet)
  end

  def statuses(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    arguments.in_groups_of(MAX_TWEETS_PER_REQUEST).map do |tweets|
      get("/1.1/statuses/lookup.json", arguments.options.merge({"id" => tweets.compact.map { |u| extract_id(u.not_nil!) }.join(", ")}), Array(Tweeter::Tweet))
    end.flatten
  end

  def destroy_status(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    arguments.map do |tweet|
      post("/1.1/statuses/destroy/#{extract_id(tweet)}.json", arguments.options, Tweeter::Tweet)
    end
  end
  alias_method :destroy_tweet, :destroy_status

  def update(status, options = nil)
    update!(status, options)
  rescue Tweeter::Error::DuplicateStatus
    user_timeline(count: 1).first
  end

  def update!(status, options = nil)
    hash = normalize_options(options)
    hash["in_reply_to_status_id"] = hash.delete("in_reply_to_status_id").not_nil! if hash.has_key?("in_reply_to_status_id")
    hash["place_id"] = hash.delete("place").not_nil! if hash.has_key?("place")
    post("/1.1/statuses/update.json", hash.merge({"status" => status}), Tweeter::Tweet)
  end

  def retweet(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    arguments.map do |tweet|
      begin
        post_retweet(extract_id(tweet), arguments.options)
      rescue exception
        next
      end
    end.compact
  end

  def retweet!(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    arguments.map do |tweet|
      post_retweet(extract_id(tweet), arguments.options)
    end.compact
  end

  def update_with_media(status, media, options = nil)
    options = normalize_options(options)
    media_ids = array_wrap(media).map do |medium|
      upload(medium)[:media_id]
    end
    update!(status, options.merge({ "media_ids" => media_ids.join(",") }))
  end

  def oembed(tweet, options = nil)
    options = normalize_options(options)
    options["id"] = extract_id(tweet).to_s
    get("/1.1/statuses/oembed.json", options, Tweeter::OEmbed)
  end

  def oembeds(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    arguments.map do |tweet|
      oembed(extract_id(tweet), arguments.options)
    end
  end

  def retweeter_ids(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    arguments.options["id"] ||= extract_id(arguments.first).to_s
    get("/1.1/statuses/retweeters/ids.json", arguments.options, "ids", Int64)
  end

  def unretweet(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    arguments.each do |tweet|
      begin
        post_unretweet(extract_id(tweet), arguments.options)
      rescue Tweeter::Error::NotFound
        next
      end
    end.compact
  end

  private def upload(media)

  end

  private def array_wrap(object)
    if object.responds_to?(:to_a)
      object.to_a
    else
      [object]
    end
  end

  private def post_retweet(tweet, options = nil)
    post("/1.1/statuses/retweet/#{extract_id(tweet)}.json", normalize_options(options))
  end

  private def post_unretweet(tweet, options = nil)
    post("/1.1/statuses/unretweet/#{extract_id(tweet)}.json", normalize_options(options))
  end
end
