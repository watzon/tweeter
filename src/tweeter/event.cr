require "./base"
require "./direct_message"

module Tweeter
  class Event < Tweeter::Base
    create_initializer({
      type:              {type: String},
      id:                {type: Int64, nilable: true, converter: Int::StringConverter},
      created_timestamp: {type: String, nilable: true},
      message_create:    {type: MessageCreate, nilable: true},
    })

    class MessageCreate < Tweeter::Base
      create_initializer({
        target:       {type: Hash(String, String), nilable: true},
        sender_id:    {type: Int64, nilable: true, converter: Int::StringConverter},
        message_data: {type: Tweeter::DirectMessage, nilable: true},
      })
    end
  end
end
