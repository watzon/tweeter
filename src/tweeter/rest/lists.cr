require "uri"
require "../arguments"
require "../cursor"
require "../error"
require "../list"
require "./request"
require "./utils"
require "../tweet"
require "../user"
require "../utils"

module Tweeter::REST::Lists
  include Tweeter::REST::Utils
  include Tweeter::Utils

  MAX_USERS_PER_REQUEST = 100

  def lists(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    merge_user!(arguments.options, arguments.pop?) if arguments.size > 0
    get("/1.1/lists/list.json", arguments.options, Array(Tweeter::List))
  end
  alias_method :lists_subscribed_to, :lists

  def list_timeline(list, owner = nil, options = nil)
    options = normalize_options(options)
    merge_list!(options, list)
    merge_owner!(options, owner) if owner
    get("/1.1/lists/statuses.json", options, Array(Tweeter::Tweet))
  end

  def remove_list_member(list, user, options = nil)
    options = normalize_options(options)
    merge_list!(options, list)
    merge_user!(options, user)
    get("/1.1/lists/members/destroy.json", options, Tweeter::List)
  end

  def memberships(user = nil, options = nil)
    options = normalize_options(options)
    merge_user!(options, user)
    get("/1.1/lists/memberships.json", options, "lists", Tweeter::List)
  end

  def list_subscribers(list, user = nil, options = nil)
    options = normalize_options(options)
    merge_list!(options, list)
    merge_user!(options, user)
    get("/1.1/lists/subscribers.json", options, "users", Tweeter::User)
  end

  def list_subscribe(list, user = nil, options = nil)
    options = normalize_options(options)
    merge_list!(options, list)
    merge_user!(options, user)
    post("/1.1/lists/subscribers/create.json", options, Tweeter::List)
  end

  def list_subscriber?(user, list, options = nil)

  end

  private def merge_list!(hash, list)
    hash["list_id"] = extract_id(list).to_s
  end

  private def merge_slug_and_owner!(hash, path)
    list = path.split("/")
    hash["slug"] = list.pop
    hash["owner_screen_name"] = list.pop unless list.empty?
  end

  private def merge_list_and_owner!(hash, list)
    merge_list!(hash, list.id)
    merge_owner!(hash, list.user)
  end

  private def merge_owner!(hash, user)
    return hash if hash["owner_id"]? || hash["owner_screen_name"]?
    if user
      merge_user!(hash, user, "owner")
      hash["owner_id"] = hash.delete("owner_user_id").not_nil! if hash["owner_user_id"]?
    else
      hash["owner_id"] = user_id.to_s
    end
    hash
  end
end
