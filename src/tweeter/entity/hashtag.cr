require "../base"

module Tweeter::Entity
  class Hashtag < Tweeter::Base
    PROPERTIES = {
      text:    String,
      indices: Tuple(Int32, Int32),
    }

    create_initializer({{PROPERTIES}})
  end
end
