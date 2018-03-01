require "./base"

module Tweeter
  class Identity < Tweeter::Base
    create_initializer({
      id: { type: Int64 }
    })
  end
end
