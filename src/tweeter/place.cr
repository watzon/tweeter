require "./base"

module Tweeter
  class Place < Tweeter::Base
    PROPERTIES = {
      id:           {type: String, nilable: true},
      name:         {type: String, nilable: true},
      full_name:    {type: String, nilable: true},
      place_type:   {type: String, nilable: true},
      url:          {type: String, nilable: true},
      country:      {type: String, nilable: true},
      country_code: {type: String, nilable: true},
      bounding_box: {type: BoundingBox, nilable: true},
      attributes:   {type: Hash(String, JSON::Any), nilable: true},
    }

    create_initializer({{PROPERTIES}})

    class BoundingBox < Tweeter::Base
      PROPERTIES = {
        coordinates: {type: Array(Array(Tuple(Float64, Float64))), nilable: true},
        type:        {type: String, nilable: true},
      }

      create_initializer({{PROPERTIES}})
    end
  end
end
