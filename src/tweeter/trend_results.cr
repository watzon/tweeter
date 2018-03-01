module Tweeter
  class TrendResults < Tweeter::Base
    create_initializer({
      trends:     {type: Array(Trend), default: [] of Trend},
      locations:  {type: Array(Location), nilable: true},
      as_of:      {type: Time, nilable: true, converter: Time::TrendConverter},
      created_at: {type: Time, nilable: true, converter: Time::TrendConverter},
    })

    class Trend < Tweeter::Base
      create_initializer({
        name:             {type: String, nilable: true},
        url:              {type: URI, nilable: true, converter: URI::StringConverter},
        promoted_content: {type: Bool, default: false},
        query:            {type: String, nilable: true},
        tweet_volume:     {type: Int32, nilable: true},
      })
    end

    class Location < Tweeter::Base
      create_initializer({
        name:  {type: String, nilable: true},
        woeid: {type: Int32, nilable: true},
      })
    end
  end
end
