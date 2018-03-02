require "../arguments"
require "../direct_message"
require "../event"
require "./request"
require "./utils"
require "../user"
require "../utils"

module Tweeter::REST::DirectMessages
  include Tweeter::REST::Utils
  include Tweeter::Utils

  def direct_messages(options = nil)
    get("/1.1/direct_messages/events/list.json", normalize_options(options), "events", Tweeter::DirectMessage, default_cursor: false)
  end

  def direct_message(id, options = nil)
    options = normalize_options(options).merge({"id" => id.to_s})
    response = get("/1.1/direct_messages/events/show.json", options)["event"]
    Tweeter::Event.from_json(response.to_json)
  end

  def destroy_direct_message(id, options = nil)
    options = normalize_options(options).merge({"id" => id.to_s})
    request(:delete, "/1.1/direct_messages/events/destroy.json", options)
  end

  def create_direct_message(user, text, options = nil)
  end

  alias_method :dm, :create_direct_message
end
