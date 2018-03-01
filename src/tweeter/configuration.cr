require "./base"

module Tweeter
  class Configuration < Tweeter::Base
    create_initializer({
      characters_reserved_per_media: {type: Int32, nilable: true},
      dm_text_character_limit:       {type: Int32, nilable: true},
      max_media_per_upload:          {type: Int32, nilable: true},
      photo_size_limit:              {type: Int32, nilable: true},
      photo_sizes:                   {type: Hash(String, PhotoSize), nilable: true},
      short_url_length:              {type: Int32, nilable: true},
      short_url_length_https:        {type: Int32, nilable: true},
      non_username_paths:            {type: Array(String), nilable: true},
    })

    class PhotoSize < Tweeter::Base
      create_initializer({
        h:      {type: Int32, nilable: true},
        resize: {type: String, nilable: true},
        w:      {type: Int32, nilable: true},
      })
    end
  end
end
