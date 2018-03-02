require "uri"

require "../arguments"
require "../cursor"
require "./request"
require "../user"

module Tweeter::REST::Utils
  DEFAULT_CURSOR = -1

  alias UserArgs = Int64 | String | URI | Tweeter::User

  @@user_id : Int64?

  def extract_id(object)
    case object
    when ::Int
      object
    when ::String
      object.split("/").last.to_i64
    when URI
      object.path.not_nil!.split("/").last.to_i64
    when Tweeter::Identity
      object.id
    end
  end

  def normalize_options(options = nil)
    return {} of String => String if options.nil?
    options.to_h.transform_keys(&.to_s)
  end

  def get(path : String, options = nil)
    request("get", path, options)
  end

  def get(path : String, options, klass)
    request("get", path, options, klass)
  end

  def get(path : String, options : Hash(String, String), collection_name : String | Symbol, klass, *, default_cursor = true)
    merge_default_cursor!(options) if default_cursor
    request = Tweeter::REST::Request.new(self, "get", path, options)
    Tweeter::Cursor.new(collection_name.to_s, klass, request)
  end

  def post(path : String, options = nil)
    request("post", path, options)
  end

  def post(path : String, options, klass)
    request("post", path, options, klass)
  end

  def request(method, path : String, options = nil)
    Tweeter::REST::Request.new(self, method.to_s, path, options).perform
  end

  def request(method, path : String, options, klass)
    response = request(method.to_s, path, options)
    klass.from_json(response.to_json)
  end

  # def request(method : String, path : String, file : File, options)
  #   Tweeter::REST::Request.new(self, "multipart_post", path, options.merge({"file" => file})).perform
  # end

  def user_id
    @@user_id ||= verify_credentials({skip_status: true}).id
  end

  def user_id?
    !!@user_id
  end

  def merge_default_cursor!(options)
    options["cursor"] = DEFAULT_CURSOR.to_s unless options["cursor"]?
  end

  def merge_user(hash, user, prefix = nil)
    merge_user!(hash.dup, user, prefix)
  end

  def merge_user!(hash, user, prefix = nil)
    case user
    when Int
      set_compound_key("user_id", user, hash, prefix)
    when String
      set_compound_key("screen_name", user, hash, prefix)
    when URI
      set_compound_key("screen_name", user.path.not_nil!.split("/").last, hash, prefix)
    when Tweeter::User
      set_compound_key("user_id", user.id, hash, prefix)
    end
  end

  def set_compound_key(key, value, hash, prefix = nil)
    compound_key = [prefix, key].compact.join("_")
    hash[compound_key] = value.to_s
    hash
  end

  def merge_users(hash, users)
    copy = hash.dup
    merge_users!(copy, users)
    copy
  end

  def merge_users!(hash, users)
    user_ids, screen_names = collect_users(users)
    hash["user_id"] = user_ids.join(',') unless user_ids.empty?
    hash["screen_name"] = screen_names.join(',') unless screen_names.empty?
  end

  def collect_users(users)
    user_ids = [] of Int64
    screen_names = [] of String
    users.each do |user|
      case user
      when Int           then user_ids << user.to_i64
      when Tweeter::User then user_ids << user.id.to_i64
      when String        then screen_names << user
      when URI           then screen_names << user.path.not_nil!.split('/').last
      end
    end
    [user_ids, screen_names]
  end
end
