require "./identity"
require "./user"

module Tweeter
  class List < Tweeter::Identity
    create_initializer({
      slug:             { type: String,         nilable: true },
      name:             { type: String,         nilable: true },
      created_at:       { type: Time,           nilable: true, converter: Time::ParserConverter.new("%a %b %d %T %z %Y") },
      uri:              { type: String,         nilable: true },
      subscriber_count: { type: Int64,          nilable: true },
      member_count:     { type: Int64,          nilable: true },
      mode:             { type: String,         nilable: true },
      full_name:        { type: String,         nilable: true },
      description:      { type: String,         nilable: true },
      user:             { type: Tweeter::User,  nilable: true },
    })

    equalize({:id, :id})

    def members_url
      if uri?
        URi.parse("#{uri}/members")
      end
    end

    def subscribers_url
      if uri?
        URi.parse("#{uri}/members")
      end
    end

    def url
      if slug? && user && user.not_nil!.screen_name
        URI.parse("https://twitter.com/#{user.not_nil!.screen_name}/#{slug}")
      end
    end

    def uri?
      !!uri
    end

    def slug?
      !!slug
    end
  end
end
