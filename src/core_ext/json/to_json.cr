module Time::ISO_8601_Converter
  def self.to_json(value : Time, json : JSON::Builder)
    json.string(value.to_s("%a %b %d %T %z %Y"))
  end
end

module Time::TrendConverter
  def self.to_json(value : Time, json : JSON::Builder)
    json.string(value.to_s("%FT%TZ"))
  end
end

class URI::StringConverter
  def self.to_json(value : URI, json : JSON::Builder)
    json.string(value.to_s)
  end
end

struct Int::StringConverter
  def self.to_json(value : Int, json : JSON::Builder)
    json.string(value.to_s)
  end
end
