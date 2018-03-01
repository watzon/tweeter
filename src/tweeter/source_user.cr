require "./basic_user"

module Tweeter
  class SourceUser < Tweeter::BasicUser
    create_initializer({
      can_dm:                {type: Bool, nilable: true},
      blocking:              {type: Bool, nilable: true},
      muting:                {type: Bool, nilable: true},
      all_replies:           {type: Int32 | Int64, nilable: true},
      want_retweets:         {type: Bool, nilable: true},
      marked_spam:           {type: Bool, nilable: true},
      followed_by:           {type: Bool, nilable: true},
      notifications_enabled: {type: Bool, nilable: true},
    })
  end
end
