require "../configuration"
require "../language"
require "./request"
require "./utils"

module Tweeter::REST::Help
  def configuration(options = nil)
    get("/1.1/help/configuration.json", normalize_options(options), Tweeter::Configuration)
  end

  def languages(options = nil)
    get("/1.1/help/languages.json", normalize_options(options), Tweeter::Language)
  end

  def privacy(options = nil)
    get("/1.1/help/privacy.json", normalize_options(options))["privacy"].as_s
  end

  def tos(options = nil)
    get("/1.1/help/tos.json", normalize_options(options))["tos"].as_s
  end
end
