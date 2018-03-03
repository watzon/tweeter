require "uri"
require "./base"
require "./basic_user"
require "./entity/url"

module Tweeter
  class User < Tweeter::BasicUser
    PROPERTIES = {
      name:        {type: String, nilable: true},
      location:    {type: String, nilable: true},
      description: {type: String, nilable: true},
      url:         {type: URI, nilable: true, converter: URI::StringConverter},
      entities:    {type: ProfileEntities, nilable: true},
      # protected:                          { type: Bool,             nilable: true },
      followers_count:                    {type: Int32, nilable: true},
      friends_count:                      {type: Int32, nilable: true},
      listed_count:                       {type: Int32, nilable: true},
      created_at:                         {type: Time, nilable: true, converter: Time::ISO_8601_Converter},
      favourites_count:                   {type: Int32, nilable: true},
      utc_offset:                         {type: Int32, nilable: true},
      time_zone:                          {type: String, nilable: true},
      geo_enabled:                        {type: Bool, nilable: true},
      verified:                           {type: Bool, nilable: true},
      statuses_count:                     {type: Int32, nilable: true},
      lang:                               {type: String, nilable: true},
      contributors_enabled:               {type: Bool, nilable: true},
      is_translator:                      {type: Bool, nilable: true},
      profile_background_color:           {type: String, nilable: true},
      profile_background_image_url:       {type: String, nilable: true},
      profile_background_image_url_https: {type: String, nilable: true},
      profile_background_tile:            {type: Bool, nilable: true},
      profile_image_url:                  {type: String, nilable: true},
      profile_image_url_https:            {type: String, nilable: true},
      profile_banner_url:                 {type: String, nilable: true},
      profile_link_color:                 {type: String, nilable: true},
      profile_sidebar_border_color:       {type: String, nilable: true},
      profile_sidebar_fill_color:         {type: String, nilable: true},
      profile_text_color:                 {type: String, nilable: true},
      profile_use_background_image:       {type: Bool, nilable: true},
      default_profile:                    {type: Bool, nilable: true},
      default_profile_image:              {type: Bool, nilable: true},
      follow_request_sent:                {type: Bool, nilable: true},
      notifications:                      {type: Bool, nilable: true},
      suspended:                          {type: Bool, nilable: true},
      needs_phone_verification:           {type: Bool, nilable: true},
      connections:                        {type: Array(String), default: [] of String},
    }

    create_initializer({{PROPERTIES}})

    equalize({:id, :id})

    alias_method :favourites_count, :favorites_count
    alias_method :statuses_count, :tweets_count
    alias_method :status, :tweet
    alias_method :status?, :tweet?
    alias_method :status?, :tweeted?

    def created?
      !!created_at
    end

    def description_urls
      if entities = @entities
        if description = entities.description
          if urls = description.urls
            return urls
          end
        end
      end
      [] of Tweeter::Entity::URL
    end

    def description_urls?
      return false unless description_urls.size > 0
      true
    end

    def website_urls
      if entities = @entities
        if url = entities.url
          if urls = url.urls
            return urls
          end
        end
      end
      [] of Tweeter::Entity::URL
    end

    def website_urls?
      return false unless website_urls.size > 0
      true
    end

    def entities?
      if ents = entities
        if u = ents.url
          return true if u.urls && u.urls.not_nil!.size > 0
        end
        if d = ents.description
          return true if d.urls && d.urls.not_nil!.size > 0
        end
      end
      false
    end

    def uri
      URI.parse("https://twitter.com/#{screen_name}") unless screen_name.nil?
    end

    def website
      if website_urls?
        if wurl = website_urls.first.expanded_url || website_urls.first.url
          wurl
        end
      elsif wurl = url
        wurl
      end
    end

    def website?
      !website.nil?
    end

    class ProfileEntities < Tweeter::Base
      PROPERTIES = {
        url:         {type: URLs, nilable: true},
        description: {type: Description, nilable: true},
      }

      create_initializer({{PROPERTIES}})

      class URLs < Tweeter::Base
        PROPERTIES = {
          urls: {type: Array(Entity::URL), nilable: true},
        }

        create_initializer({{PROPERTIES}})
      end

      class Description < Tweeter::Base
        PROPERTIES = {
          urls: {type: Array(Entity::URL), nilable: true},
        }

        create_initializer({{PROPERTIES}})
      end
    end
  end
end
