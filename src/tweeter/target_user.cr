require "./basic_user"

module Tweeter
  class TargetUser < Tweeter::BasicUser
    create_initializer({
      followed_by: {type: Bool, nilable: true},
    })
  end
end
