require "./base"
require "./source_user"
require "./target_user"

module Tweeter
  class Relationship < Tweeter::Base
    create_initializer({
      source: {type: SourceUser, nilable: true},
      target: {type: TargetUser, nilable: true},
    })
  end
end
