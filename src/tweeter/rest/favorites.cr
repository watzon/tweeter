require "../arguments"
require "../error"
require "./utils"
require "../tweet"
require "../user"
require "../utils"

module Tweeter::REST::Favorites
  include Tweeter::REST::Utils
  include Tweeter::Utils

  def favorites(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    merge_user!(arguments.options, arguments.pop) if arguments.size > 0
    get("/1.1/favorites/list.json", arguments.options, Array(Tweeter::Tweet))
  end

  def unfavorite(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    arguments.map do |tweet|
      begin
        post("/1.1/favorites/destroy.json", arguments.options.merge({"id" => extract_id(tweet)}), Tweeter::Tweet)
      rescue Tweeter::Error::NotFound
        next
      end
    end.compact
  end

  alias_method :destroy_favorite, :unfavorite

  def unfavorite!(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    arguments.map do |tweet|
      post("/1.1/favorites/destroy.json", arguments.options.merge({"id" => extract_id(tweet)}), Tweeter::Tweet)
    end
  end

  alias_method :destroy_favorite!, :unfavorite!

  def favorite(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    arguments.map do |tweet|
      begin
        post("/1.1/favorites/create.json", arguments.options.merge({"id" => extract_id(tweet)}), Tweeter::Tweet)
      rescue Tweeter::Error::AlreadyFavorited
      rescue Tweeter::Error::NotFound
        next
      end
    end.compact
  end

  alias_method :fav, :favorite
  alias_method :fave, :favorite

  def favorite!(*args)
    arguments = Tweeter::Arguments(UserArgs).new(args)
    arguments.map do |tweet|
      post("/1.1/favorites/create.json", arguments.options.merge({"id" => extract_id(tweet)}), Tweeter::Tweet)
    end.compact
  end

  alias_method :fav!, :favorite!
  alias_method :fave!, :favorite!
end
