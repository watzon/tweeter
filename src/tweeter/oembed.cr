require "uri"
require "./base"

module Tweeter
  class OEmbed < Tweeter::Base
    create_initializer({
      height:        {type: Int32, nilable: true},
      width:         {type: Int32, nilable: true},
      author_name:   {type: String, nilable: true},
      provider_name: {type: String, nilable: true},
      cache_age:     {type: String, nilable: true},
      html:          {type: String, nilable: true},
      type:          {type: String, nilable: true},
      version:       {type: String, nilable: true},
      author_uri:    {type: URI, nilable: true, converter: URI::StringConverter},
      provider_uri:  {type: URI, nilable: true, converter: URI::StringConverter},
      uri:           {type: URI, nilable: true, converter: URI::StringConverter},
    })
  end
end
