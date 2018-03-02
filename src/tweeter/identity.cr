require "./base"

module Tweeter
  class Identity < Tweeter::Base
    create_initializer({
      id:     {type: Int64},
      id_str: {type: String, nilable: true},
    })
  end
end
