require "./identity"

module Tweeter
  class BasicUser < Tweeter::Identity
    create_initializer({
      screen_name: {type: String, nilable: true},
      following:   {type: Bool, nilable: true},
    })

    equalize({:id, :id})
  end
end
