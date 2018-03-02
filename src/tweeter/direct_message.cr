require "./base"

module Tweeter
  class DirectMessage < Tweeter::Base
    create_initializer({
      id:                    {type: Int64, nilable: true, converter: Int::StringConverter},
      text:                  {type: String, nilable: true},
      recipient:             {type: Tweeter::User, nilable: true},
      recipient_id:          {type: Int64, nilable: true, converter: Int::StringConverter},
      recipient_screen_name: {type: String, nilable: true},
      sender:                {type: Tweeter::User, nilable: true},
      sender_id:             {type: Int64, nilable: true, converter: Int::StringConverter},
      sender_screen_name:    {type: String, nilable: true},
      entities:              {type: Tweeter::Entities, nilable: true},
      created_at:            {type: String, nilable: true},
    })
  end
end
