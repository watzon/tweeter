require "../base"

module Tweeter::Entity
  class UserMention < Tweeter::Base
    PROPERTIES = {
      id:          {type: Int32 | Int64, nilable: true},
      id_str:      {type: String, nilable: true},
      name:        {type: String, nilable: true},
      indices:     {type: Tuple(Int32, Int32), nilable: true},
      screen_name: {type: String, nilable: true},
    }

    create_initializer({{PROPERTIES}})
  end
end
