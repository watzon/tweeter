require "./base"
require "./tweet"

module Tweeter
  class SearchResults < Tweeter::Base
    include ::Indexable(Tweeter::Tweet)

    create_initializer({
      statuses:        {type: Array(Tweeter::Tweet), default: [] of Tweeter::Tweet},
      search_metadata: {type: SearchMetadata, nilable: true},
    })

    def each
      statuses.each { |status| yield(status) }
    end

    class SearchMetadata < Tweeter::Base
      create_initializer({
        max_id:       {type: Int64, nilable: true},
        since_id:     {type: Int64, nilable: true},
        refresh_url:  {type: String, nilable: true},
        next_results: {type: String, nilable: true},
        count:        {type: Int32, nilable: true},
        completed_in: {type: Float64, nilable: true},
        since_id_str: {type: String, nilable: true},
        query:        {type: String, nilable: true},
        max_id_str:   {type: String, nilable: true},
      })
    end
  end
end
