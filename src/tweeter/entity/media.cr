require "../base"

module Tweeter::Entity
  class Media < Tweeter::Base
    PROPERTIES = {
      id:              {type: Int32 | Int64, nilable: true},
      id_str:          {type: String, nilable: true},
      type:            {type: String, nilable: true},
      sizes:           {type: Hash(String, Size), nilable: true},
      indices:         {type: Array(Int32), nilable: true},
      url:             {type: String, nilable: true},
      media_url:       {type: String, nilable: true},
      display_url:     {type: String, nilable: true},
      expanded_url:    {type: String, nilable: true},
      media_url_https: {type: String, nilable: true},
    }

    create_initializer({{PROPERTIES}})

    class Size < Tweeter::Base
      PROPERTIES = {
        h:      Int32,
        resize: String,
        w:      Int32,
      }

      create_initializer({{PROPERTIES}})
    end
  end
end
