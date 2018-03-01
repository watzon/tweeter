require "../base"

module Tweeter::Entity
  class Symbol < Tweeter::Base
    PROPERTIES = {
      text:    String,
      indices: Tuple(Int32, Int32),
    }

    create_initializer({{PROPERTIES}})
  end
end
