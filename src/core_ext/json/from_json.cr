module Time::ISO_8601_Converter
  def self.from_json(value : JSON::PullParser) : Time
    Time.parse(value.read_string, "%a %b %d %T %z %Y", Time::Kind::Utc)
  end
end

module Time::TrendConverter
  def self.from_json(value : JSON::PullParser) : Time
    Time.parse(value.read_string, "%FT%TZ", Time::Kind::Utc)
  end
end

class URI::StringConverter
  def self.from_json(value : JSON::PullParser) : URI
    URI.parse(value.read_string)
  end
end

struct Int::StringConverter
  def self.from_json(value : JSON::PullParser) : Int64
    value.read_string.to_i64
  end
end
