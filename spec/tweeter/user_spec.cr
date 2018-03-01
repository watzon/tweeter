require "../spec_helper"

describe Tweeter::User do
  describe "#==" do
    it "returns true when object IDs are the same" do
      user = Tweeter::User.new(id: 1_i64, screen_name: "foo")
      other = Tweeter::User.new(id: 1_i64, screen_name: "bar")
      expect(user == other).to be_true
    end

    it "returns false when object IDs are different" do
      user = Tweeter::User.new(id: 1_i64)
      other = Tweeter::User.new(id: 2_i64)
      expect(user == other).to be_false
    end

    it "returns false when classes are different" do
      user = Tweeter::User.new(id: 1_i64)
      other = Tweeter::Identity.new(id: 1_i64)
      expect(user == other).to be_false
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      user = Tweeter::User.new(
        id: 2252786816_i64,
        created_at: Time.parse("Mon Jul 16 12:59:01 +0000 2007", "%a %b %d %T %z %Y", Time::Kind::Utc))
      expect(user.created_at).to be_a Time
      expect(user.created_at.not_nil!.utc?).to be_true
    end

    it "returns nil when created_at is not set" do
      user = Tweeter::User.new(id: 2252786816_i64)
      expect(user.created?).to eq false
    end
  end

  describe "#description_urls" do
    it "returns an array of Entity::URLs when description URL entities are set" do
      entities = Tweeter::User::ProfileEntities.new(
        description: Tweeter::User::ProfileEntities::Description.new(
          urls: [
            Tweeter::Entity::URL.new(
              url: URI.parse("https://t.co/L2xIBazMPf"),
              expanded_url: URI.parse("http://example.com/expanded"),
              display_url: "example.com/expanded...",
              indices: {10, 33},
              unwound: nil
            ),
          ]
        )
      )
      user = Tweeter::User.new(id: 2252786816_i64, entities: entities)
      expect(user.description_urls).to be_a Array(Tweeter::Entity::URL)
    end

    it "returns an empty array when not set" do
      user = Tweeter::User.new(id: 2252786816_i64)
      expect(user.description_urls.empty?).to be_true
    end
  end

  describe "#description_urls?" do
    it "returns true when a tweet contains description URL entities" do
      entities = Tweeter::User::ProfileEntities.new(
        description: Tweeter::User::ProfileEntities::Description.new(
          urls: [
            Tweeter::Entity::URL.new(
              url: URI.parse("https://t.co/L2xIBazMPf"),
              expanded_url: URI.parse("http://example.com/expanded"),
              display_url: "example.com/expanded...",
              indices: {10, 33},
              unwound: nil
            ),
          ]
        )
      )
      user = Tweeter::User.new(id: 2252786816_i64, entities: entities)
      expect(user.description_urls?).to be_true
    end

    it "returns false when no entities are present" do
      user = Tweeter::User.new(id: 2252786816_i64)
      expect(user.description_urls?).to be_false
    end
  end

  describe "#entities?" do
    it "returns true if there are entities set" do
      entities = Tweeter::User::ProfileEntities.new(
        description: Tweeter::User::ProfileEntities::Description.new(
          urls: [
            Tweeter::Entity::URL.new(
              url: URI.parse("https://t.co/L2xIBazMPf"),
              expanded_url: URI.parse("http://example.com/expanded"),
              display_url: "example.com/expanded...",
              indices: {10, 33},
              unwound: nil
            ),
          ]
        )
      )
      user = Tweeter::User.new(id: 2252786816_i64, entities: entities)
      expect(user.entities?).to be_true
    end

    it "returns false if entites is blank" do
      entities = Tweeter::User::ProfileEntities.new(
        description: Tweeter::User::ProfileEntities::Description.new(
          urls: [] of Tweeter::Entity::URL
        )
      )
      user = Tweeter::User.new(id: 2252786816_i64, entities: entities)
      expect(user.entities?).to be_false
    end

    it "returns false if no entities are set" do
      user = Tweeter::User.new(id: 2252786816_i64)
      expect(user.entities?).to be_false
    end
  end

  describe "#url" do
    it "returns the URL to the user" do
      user = Tweeter::User.new(id: 2252786816_i64, screen_name: "_watzon")
      expect(user.uri).to be_a URI
      expect(user.uri.to_s).to eq("https://twitter.com/_watzon")
    end

    it "returns nil when the screen name is not set" do
      user = Tweeter::User.new(id: 2252786816_i64)
      expect(user.uri).to be_nil
    end
  end

  describe "#website" do
    it "returns a URI when the url is set" do
      user = Tweeter::User.new(id: 2252786816_i64, url: URI.parse("https://watzon.me"))
      expect(user.website).to be_a URI
      expect(user.website.to_s).to eq("https://watzon.me")
    end

    it "returns a URI when the entites contain url entries" do
      entities = Tweeter::User::ProfileEntities.new(
        url: Tweeter::User::ProfileEntities::URLs.new(
          urls: [
            Tweeter::Entity::URL.new(
              url: URI.parse("https://t.co/L2xIBazMPf"),
              expanded_url: URI.parse("http://example.com/expanded"),
              display_url: "example.com/expanded...",
              indices: {10, 33},
              unwound: nil
            ),
          ]
        )
      )
      user = Tweeter::User.new(id: 2252786816_i64, entities: entities)
      expect(user.website).to be_a URI
      expect(user.website).to eq(URI.parse("http://example.com/expanded"))
    end
  end

  describe "#website?" do
    it "returns true when the user contains website URL entities" do
      entities = Tweeter::User::ProfileEntities.new(
        url: Tweeter::User::ProfileEntities::URLs.new(
          urls: [
            Tweeter::Entity::URL.new(
              url: URI.parse("https://t.co/L2xIBazMPf"),
              expanded_url: URI.parse("http://example.com/expanded"),
              display_url: "example.com/expanded...",
              indices: {10, 33},
              unwound: nil
            ),
          ]
        )
      )
      user = Tweeter::User.new(id: 2252786816_i64, entities: entities)
      expect(user.website?).to be_true
    end

    it "returns false when the url is not set" do
      user = Tweeter::User.new(id: 2252786816_i64)
      expect(user.website?).to be_false
    end
  end

  describe "#website_urls" do
    it "returns an array or Entity::URL's when website URL entities are set" do
      entities = Tweeter::User::ProfileEntities.new(
        url: Tweeter::User::ProfileEntities::URLs.new(
          urls: [
            Tweeter::Entity::URL.new(
              url: URI.parse("https://t.co/L2xIBazMPf"),
              expanded_url: URI.parse("http://example.com/expanded"),
              display_url: "example.com/expanded...",
              indices: {10, 33},
              unwound: nil
            ),
          ]
        )
      )
      user = Tweeter::User.new(id: 2252786816_i64, entities: entities)
      expect(user.website_urls).to be_a Array(Tweeter::Entity::URL)
      expect(user.website_urls.first).to be_a Tweeter::Entity::URL
      expect(user.website_urls.first.indices).to eq({10, 33})
    end

    it "is empty when not set" do
      entities = Tweeter::User::ProfileEntities.new(
        url: Tweeter::User::ProfileEntities::URLs.new(
          urls: [] of Tweeter::Entity::URL
        )
      )
      user = Tweeter::User.new(id: 2252786816_i64, entities: entities)
      expect(user.website_urls.empty?).to be_true
    end
  end

  describe "#website_urls?" do
    it "returns true when the user contains website URL entities" do
      entities = Tweeter::User::ProfileEntities.new(
        url: Tweeter::User::ProfileEntities::URLs.new(
          urls: [
            Tweeter::Entity::URL.new(
              url: URI.parse("https://t.co/L2xIBazMPf"),
              expanded_url: URI.parse("http://example.com/expanded"),
              display_url: "example.com/expanded...",
              indices: {10, 33},
              unwound: nil
            ),
          ]
        )
      )
      user = Tweeter::User.new(id: 2252786816_i64, entities: entities)
      expect(user.website_urls?).to be_true
    end

    it "returns fase when no entities are present" do
      user = Tweeter::User.new(id: 2252786816_i64)
      expect(user.website_urls?).to be_false
    end
  end
end
