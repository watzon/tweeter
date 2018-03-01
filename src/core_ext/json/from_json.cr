module Time::ISO_8601_Converter
  def self.from_json(value : JSON::PullParser) : Time
    Time.parse(value.read_string, "%a %b %d %T %z %Y", Time::Kind::Utc)
  end
end

module URI::StringConverter
  def self.from_json(value : JSON::PullParser) : URI
    URI.parse(value.read_string)
  end
end
