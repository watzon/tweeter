require "../base"

module Tweeter::Entity
  class Poll < Tweeter::Base
    PROPERTIES = {
      options:          Array(Option),
      end_datetime:     {type: Time, converter: Time::Format.new("%a %b %d %T +0000 %Y")},
      duration_minutes: Int32,
    }

    create_initializer({{PROPERTIES}})

    class Option < Tweeter::Base
      PROPERTIES = {
        position: Int32,
        text:     String,
      }

      create_initializer({{PROPERTIES}})
    end
  end
end
