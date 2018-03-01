require "./base"

module Tweeter
  class Identity < Tweeter::Base
    create_initializer({
      id: {type: Int32 | Int64},
    })
  end
end
