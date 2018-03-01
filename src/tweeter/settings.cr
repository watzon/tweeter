require "./base"

module Tweeter
  class Settings < Tweeter::Base
    PROPERTIES = {
      always_use_https:      Bool,
      discoverable_by_email: Bool,
      geo_enabled:           Bool,
      language:              String,
      # protected:                  Bool,
      screen_name:                String,
      show_all_inline_media:      Bool?,
      sleep_time:                 SleepTime,
      time_zone:                  TimeZone,
      trend_location:             Array(TrendLocation),
      use_cookie_personalization: Bool,
      allow_contributor_request:  String,
    }

    create_initializer({{PROPERTIES}})

    class SleepTime < Tweeter::Base
      PROPERTIES = {
        enabled:    Bool,
        end_time:   String?,
        start_time: String?,
      }

      create_initializer({{PROPERTIES}})
    end

    class TimeZone < Tweeter::Base
      PROPERTIES = {
        name:        String,
        tzinfo_name: String,
        utc_offset:  Int32,
      }

      create_initializer({{PROPERTIES}})
    end

    class TrendLocation < Tweeter::Base
      PROPERTIES = {
        country:      String,
        country_code: {key: "countryCode", type: String},
        name:         String,
        parentid:     Int32,
        place_type:   {key: "placeType", type: PlaceType},
        url:          String,
        woeid:        Int32,
      }

      create_initializer({{PROPERTIES}})

      class PlaceType < Tweeter::Base
        PROPERTIES = {
          code: Int32,
          name: String,
        }

        create_initializer({{PROPERTIES}})
      end
    end
  end
end
