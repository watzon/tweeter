struct NamedTuple
  def to_query_string
    query = HTTP::Params.build do |form_builder|
      each do |key, value|
        form_builder.add(key.to_s, value)
      end
    end
    query.empty? ? "" : "?" + query
  end
end
