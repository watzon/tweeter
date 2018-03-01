require "./base"
require "./source_user"
require "./target_user"

module Tweeter
  class Metadata < Tweeter::Base
    create_initializer({
      iso_language_code: {type: String, nilable: true},
      result_type:       {type: String, nilable: true},
    })
  end
end
