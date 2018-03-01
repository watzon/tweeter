require "uri"
require "./identity"
require "./user"
require "./entities"
require "./metadata"
require "./coordinates"
require "./place"

module Tweeter
  class Tweet < Tweeter::Identity
    PROPERTIES = {
      id_str:                    {type: String, nilable: true},
      created_at:                {type: Time, nilable: true, converter: Time::ISO_8601_Converter},
      text:                      {type: String, nilable: true},
      truncated:                 {type: Bool, nilable: true},
      entities:                  {type: Entities, nilable: true},
      source:                    {type: String, nilable: true},
      in_reply_to_status_id:     {type: Int32 | Int64, nilable: true},
      in_reply_to_status_id_str: {type: String, nilable: true},
      in_reply_to_user_id:       {type: Int32 | Int64, nilable: true},
      in_reply_to_user_id_str:   {type: String, nilable: true},
      in_reply_to_screen_name:   {type: String, nilable: true},
      user:                      {type: User, nilable: true},
      coordinates:               {type: Coordinates, nilable: true},
      place:                     {type: Place, nilable: true},
      contributors:              {type: JSON::Any, nilable: true},
      is_quote_status:           {type: Bool, nilable: true},
      current_user_retweet:      {type: Tweet, nilable: true},
      quoted_status:             {type: Tweet, nilable: true},
      retweeted_status:          {type: Tweet, nilable: true},
      retweet_count:             {type: Int32, nilable: true},
      favorite_count:            {type: Int32, nilable: true},
      favorited:                 {type: Bool, nilable: true},
      retweeted:                 {type: Bool, nilable: true},
      filter_level:              {type: String, nilable: true},
      lang:                      {type: String, nilable: true},
      possibly_sensitive:        {type: Bool, nilable: true},
      metadata:                  {type: Metadata, nilable: true},
    }

    create_initializer({{PROPERTIES}})

    equalize({:id, :id})

    def empty?
      text.nil? || text.not_nil!.empty?
    end

    {% for key in %w(retweeted_status quoted_status metadata in_reply_to_user_id user place created_at) %}
      def {{key.id}}?
        !!{{key.id}}
      end
    {% end %}

    alias_method :reply?, :in_reply_to_user_id?
    alias_method :retweet?, :retweeted_status?
    alias_method :quote?, :quoted_status?
    alias_method :created?, :created_at?

    def coordinates?
      return false if @coordinates.nil?
      return false if @coordinates.class == Tweeter::Coordinates
      true
    end

    def entities?
      if entities = @entities
        {% for ent in Tweeter::Entities::PROPERTIES.keys %}
          if entity = entities.{{ent.id}}
            return true unless entity.size < 1
          end
        {% end %}
      end
      false
    end

    {% for entity in Tweeter::Entities::PROPERTIES.keys %}
      def {{ entity.id }}
        if ents = entities
          return ents.{{ entity.id }}
        end
        {{ Tweeter::Entities::PROPERTIES[entity][:type] }}.new
      end

      def {{ entity.id }}?
        return false if entities.nil?
        return true if entities.not_nil!.{{ entity.id }}.size > 0
        false
      end
    {% end %}

    def full_text
      if txt = text
        if retweet?
          prefix = txt[/\A(RT @[a-z0-9_]{1,20}: )/i, 1]?
          [prefix, (retweeted_status ? retweeted_status.not_nil!.text : "")].compact.join
        else
          txt
        end
      end
    end

    def url
      if u = user
        if screen_name = u.screen_name
          URI.parse("https://twitter.com/#{screen_name}/status/#{id}")
        end
      end
    end

    alias_method :uri, :url
  end
end
