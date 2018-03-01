require "./base"
require "./entity/*"

module Tweeter
  class Entities < Tweeter::Base
    PROPERTIES = {
      hashtags:      {type: Array(Entity::Hashtag), default: [] of Entity::Hashtag},
      symbols:       {type: Array(Entity::Symbol), default: [] of Entity::Symbol},
      user_mentions: {type: Array(Entity::UserMention), default: [] of Entity::UserMention},
      urls:          {type: Array(Entity::URL), default: [] of Entity::URL},
      media:         {type: Array(Entity::Media), default: [] of Entity::Media},
      polls:         {type: Array(Entity::Poll), default: [] of Entity::Poll},
    }

    create_initializer({{PROPERTIES}})
  end
end
