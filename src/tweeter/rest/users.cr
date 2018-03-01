require "../arguments"
require "../error"
require "../profile_banner"
require "./request"
require "./utils"
require "../settings"
require "../user"
require "../utils"

module Tweeter::REST::Users
  include Tweeter::REST::Utils
  include Tweeter::Utils

  MAX_USERS_PER_REQUEST = 100

  def settings(options = nil)
    options = normalize_options(options)
    method = options.size.zero? ? "get" : "post"
    request(method, "/1.1/account/settings.json", options, Tweeter::Settings)
  end

  def verify_credentials(options = nil)
    get("/1.1/account/verify_credentials.json", normalize_options(options), Tweeter::User)
  end

  def update_delivery_device(device, options = nil)
    options = normalize_options(options)
    post("/1.1/account/update_delivery_device.json", options.merge({"device" => device}), Tweeter::User)
  end

  def update_profile(options = nil)
    post("/1.1/account/update_profile.json", normalize_options(options), Tweeter::User)
  end

  # def update_profile_background_image(image : File, options = nil)
  #   options = options.merge({ "key" => "image" })
  #   response = post("/1.1/account/update_profile_image.json", image, options)
  #   Tweeter::User.from_json(response)
  # end

  # def update_profile_image(image : File, options = nil)

  # end

  def blocked(options = nil)
    get("/1.1/blocks/list.json", normalize_options(options), "users", Tweeter::User)
  end

  def blocked_ids(options = nil)
    get("/1.1/blocks/list.json", normalize_options(options), "ids")
  end

  def blocked?(user, options = nil)
    user_id = get_user_id(user)
    blocked_ids(options).collect(&.to_i).include?(user_id)
  end

  def block(user, options = nil)
    user_id = get_user_id(user)
    options = normalize_options(options)
    options.merge!({user_id: user_id})
    post("/1.1/blocks/create.json", options, Tweeter::User)
  end

  def unblock(user, options = nil)
    user_id = get_user_id(user)
    options = normalize_options(options)
    options.merge!({user_id: user_id})
    post("/1.1/blocks/destroy.json", options, Tweeter::User)
  end

  def users(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    result = arguments.in_groups_of(MAX_USERS_PER_REQUEST).map do |users|
      get("/1.1/users/lookup.json", merge_users(arguments.options, users), Array(Tweeter::User))
    end
    result.flatten
  end

  def user(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    if !arguments.empty? && arguments.last
      merge_user!(arguments.options, arguments.pop)
      get("/1.1/users/show.json", arguments.options, Tweeter::User)
    else
      verify_credentials(arguments.options)
    end
  end

  def user?(user, options = nil)
    options = normalize_options(options)
    merge_user!(options, user)
    get("/1.1/users/show.json", options)
    true
  rescue Tweeter::Error::NotFound
    false
  end

  def user_search(query, options = nil)
    options = normalize_options(options)
    get("/1.1/users/search.json", options.merge({"q" => query}), Array(Tweeter::User))
  end

  def contributees(options = nil)
    get("/1.1/users/contributees.json", normalize_options(options), Array(Tweeter::User))
  end

  def contributors(options = nil)
    get("/1.1/users/contributors.json", normalize_options(options), Array(Tweeter::User))
  end

  def remove_profile_banner(options = nil)
    post("/1.1/remove_profile_banner.json", normalize_options(options))
    true
  end

  def update_profile_banner(banner, options = nil)
    options = normalize_options(options)
    post("/1.1/account/update_profile_banner.json", options.merge({"banner" => banner}))
    true
  end

  # def profile_banner(*args)
  #   arguments = Tweeter::Arguments(UserArgs).new(args)
  #   merge_user!(arguments.options, arguments.pop) unless arguments.options["user_id"]? || arguments.options["screen_name"]
  #   get("/1.1/users/profile_banner.json", arguments.options, Tweeter::ProfileBanner)
  # end

  def mute(options = nil)
    post("/1.1/mutes/users/create.json", normalize_options(options), Tweeter::User)
  end

  def unmute(options = nil)
    post("/1.1/mutes/users/destroy.json", normalize_options(options), Tweeter::User)
  end

  def muted(options = nil)
    post("/1.1/mutes/users/list.json", normalize_options(options), Array(Tweeter::User))
  end

  def muted_ids(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    merge_user!(arguments.options, arguments.pop)
    get("/1.1/mutes/users/ids.json", options, "ids")
  end

  private def get_user_id(user)
    case user
    when Int           then user
    when String, URI   then user(user).id
    when Tweeter::User then user.id
    end
  end
end
