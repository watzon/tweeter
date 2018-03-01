require "../base"

module Tweeter::Entity
  class URL < Tweeter::Base
    PROPERTIES = {
      url:          {type: URI, nilable: true, converter: URI::StringConverter},
      expanded_url: {type: URI, nilable: true, converter: URI::StringConverter},
      display_url:  {type: String, nilable: true},
      indices:      {type: Tuple(Int32, Int32), nilable: true},
      unwound:      {type: Unwound, nilable: true},
    }

    create_initializer({{PROPERTIES}})

    class Unwound < Tweeter::Base
      PROPERTIES = {
        url:         {type: URI, nilable: true, converter: URI::StringConverter},
        status:      {type: Int32, nilable: true},
        title:       {type: String, nilable: true},
        description: {type: String, nilable: true},
      }

      create_initializer({{PROPERTIES}})
    end
  end
end
