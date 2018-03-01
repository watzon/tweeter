module Time::ISO_8601_Converter
  def self.to_json(value : Time, json : JSON::Builder)
    json.string(value.to_string("%a %b %d %T %z %Y", Time::Kind::Utc))
  end
end

module Time::TrendConverter
  def self.to_json(value : Time, json : JSON::Builder)
    json.string(value.to_string("%FT%TZ", Time::Kind::Utc))
  end
end

class URI::StringConverter
  def self.to_json(value : URI, json : JSON::Builder)
    json.string(value.to_s)
  end
end
