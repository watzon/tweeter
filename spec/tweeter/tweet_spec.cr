require "../spec_helper"

describe Tweeter::Tweet do
  describe "#==" do
    it "returns true when object's IDs are the same" do
      tweet = Tweeter::Tweet.new(id: 1_i64, text: "foo")
      other = Tweeter::Tweet.new(id: 1_i64, text: "bar")
      expect(tweet == other).to be_true
    end

    it "returns false when object's IDs are different" do
      tweet = Tweeter::Tweet.new(id: 1_i64)
      other = Tweeter::Tweet.new(id: 2_i64)
      expect(tweet == other).to be_false
    end

    it "returns false when classes are different" do
      tweet = Tweeter::Tweet.new(id: 1_i64)
      other = Tweeter::Identity.new(id: 1_i64)
      expect(tweet == other).to be_false
    end
  end

  describe "#created_at" do
    it "returns a Time when set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, created_at: Time.now)
      expect(tweet.created_at).to be_a Time
    end

    it "returns nil when not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.created_at).to be_nil
    end
  end

  describe "#created?" do
    it "returns true when created_at is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, created_at: Time.now)
      expect(tweet.created?).to be_true
    end

    it "returns false when created_at is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.created?).to be_false
    end
  end

  describe "#entities?" do
    it "returns true if there are any entities set" do
      entities = Tweeter::Entities.new(
        urls: [
          Tweeter::Entity::URL.new(
            url: URI.parse("https://t.co/L2xIBazMPf"),
            expanded_url: URI.parse("http://example.com/expanded"),
            display_url: "example.com/expanded...",
            indices: {10, 33}
          ),
        ]
      )
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, entities: entities)
      expect(tweet.entities?).to be_true
    end

    it "returns false if entities is a blank list" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, entities: Tweeter::Entities.new)
      expect(tweet.entities?).to be_false
    end

    it "returns false if no entities are present" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.entities?).to be_false
    end
  end

  describe "#filter_level" do
    it "returns the filter level when filter_level is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, filter_level: "high")
      expect(tweet.filter_level).to be_a String
      expect(tweet.filter_level).to eq("high")
    end

    it "returns nil when not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.filter_level).to be_nil
    end
  end

  describe "#full_text" do
    it "returns the text of a Tweet" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, text: "BOOSH")
      expect(tweet.full_text).to be_a String
      expect(tweet.full_text).to eq("BOOSH")
    end

    it "returns the text of a Tweet without a user" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, text: "BOOSH", retweeted_status: Tweeter::Tweet.new(id: 28_561_922_517, text: "BOOSH"))
      expect(tweet.full_text).to be_a String
      expect(tweet.full_text).to eq("BOOSH")
    end

    it "returns the full text of a retweeted Tweet" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, text: "RT @watzon: BOOSH", retweeted_status: Tweeter::Tweet.new(id: 540_897_316_908_331_009, text: "BOOSH"))
      expect(tweet.full_text).to be_a String
      expect(tweet.full_text).to eq("RT @watzon: BOOSH")
    end

    it "returns nil when retweeted_status is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.full_text).to be_nil
    end
  end

  describe "#coordinates" do
    it "returns a Twitter::Coordinates::Point when coordinates is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, coordinates: Tweeter::Coordinates::Point.new)
      expect(tweet.coordinates).to be_a Tweeter::Coordinates::Point
    end

    it "returns nil when coordinates is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.coordinates).to be_nil
    end
  end

  describe "#coordinates?" do
    it "returns true when coordinates is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, coordinates: Tweeter::Coordinates::Point.new)
      expect(tweet.coordinates?).to be_true
    end

    it "returns false when coordinates is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.coordinates?).to be_false
    end

    it "returns false when coordinates is the wrong type" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, coordinates: Tweeter::Coordinates.new)
      expect(tweet.coordinates?).to be_false
    end
  end

  describe "#hashtags" do
    context "entities_set" do
      let(hashtags_array) do
        [Tweeter::Entity::Hashtag.new(text: "twitter", indices: {10, 33})]
      end

      subject do
        Tweeter::Tweet.new(id: 28669546014_i64, entities: Tweeter::Entities.new(hashtags: hashtags_array))
      end

      it "returns an array or Entity::Hashtag" do
        hashtags = subject.hashtags
        expect(hashtags).to be_a (Array(Tweeter::Entity::Hashtag))
        expect(hashtags.first.indices).to eq({10, 33})
        expect(hashtags.first.text).to eq("twitter")
      end
    end

    context "entities_set_but_empty" do
      subject do
        Tweeter::Tweet.new(id: 28669546014_i64, entities: Tweeter::Entities.new(hashtags: [] of Tweeter::Entity::Hashtag))
      end

      it "is empty" do
        expect(subject.hashtags.empty?).to be_true
      end
    end

    context "entities_not_set" do
      subject do
        Tweeter::Tweet.new(id: 28669546014_i64)
      end

      it "is empty" do
        expect(subject.hashtags.empty?).to be_true
      end
    end
  end

  describe "#hashtags?" do
    it "returns true when tweet includes hashtag entities" do
      entities = Tweeter::Entities.new(hashtags: [Tweeter::Entity::Hashtag.new(text: "twitter", indices: {10, 33})])
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, entities: entities)
      expect(tweet.hashtags?).to be_true
    end

    it "returns false when no entities are present" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.hashtags?).to be_false
    end
  end

  describe "#media" do
    it "returns media" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, entities: Tweeter::Entities.new(media: [Tweeter::Entity::Media.new(id: 1, type: "photo")]))
      expect(tweet.media).to be_a Array(Tweeter::Entity::Media)
      expect(tweet.media.first).to be_a (Tweeter::Entity::Media)
    end

    it "is empty when not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.media.empty?).to be_true
    end
  end

  describe "#media?" do
    it "returns true when tweet includes hashtag entities" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, entities: Tweeter::Entities.new(media: [Tweeter::Entity::Media.new(id: 1, type: "photo")]))
      expect(tweet.media?).to be_true
    end

    it "returns false when no entities are present" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.media?).to be_false
    end
  end

  describe "#metadata" do
    it "returns a Tweeter::Metadata when metadata is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, metadata: Tweeter::Metadata.new(result_type: "recent"))
      expect(tweet.metadata).to be_a Tweeter::Metadata
    end

    it "is nil when metadata is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.metadata).to be_nil
    end
  end

  describe "#metadata?" do
    it "returns true when metadata is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, metadata: Tweeter::Metadata.new(result_type: "recent"))
      expect(tweet.metadata?).to be_true
    end

    it "returns false when metadata is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.metadata?).to be_false
    end
  end

  describe "#place" do
    it "returns a Tweeter::Place when place is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, place: Tweeter::Place.new(id: "247f43d441defc03"))
      expect(tweet.place).to be_a Tweeter::Place
    end

    it "returns nil when place is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.place).to be_nil
    end
  end

  describe "#place?" do
    it "returns true when place is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, place: Tweeter::Place.new(id: "247f43d441defc03"))
      expect(tweet.place?).to be_true
    end

    it "returns false when place is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.place?).to be_false
    end
  end

  describe "#reply?" do
    it "returns true when there is an in-reply-to user" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, in_reply_to_user_id: 7_505_382)
      expect(tweet.reply?).to be_true
    end

    it "returns false when in_reply_to_user_id is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.reply?).to be_false
    end
  end

  describe "#retweet?" do
    it "returns true when retweeted_status is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, retweeted_status: Tweeter::Tweet.new(id: 540_897_316_908_331_009, text: "BOOSH"))
      expect(tweet.retweet?).to be_true
    end

    it "returns true when retweeted_status is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.retweet?).to be_false
    end
  end

  describe "#retweeted_status" do
    it "returns a Tweet when retweeted_status is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, retweeted_status: Tweeter::Tweet.new(id: 540_897_316_908_331_009, text: "BOOSH"))
      expect(tweet.retweeted_status).to be_a Tweeter::Tweet
      expect(tweet.retweeted_status.not_nil!.text).to eq("BOOSH")
    end

    it "returns nil when retweeted_status is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.retweeted_status).to be_nil
    end
  end

  describe "#retweeted_status?" do
    it "returns a true when retweeted_status is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, retweeted_status: Tweeter::Tweet.new(id: 540_897_316_908_331_009, text: "BOOSH"))
      expect(tweet.retweeted_status?).to be_true
    end

    it "returns false when retweeted_status is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.retweeted_status?).to be_false
    end
  end

  describe "#quoted_status" do
    it "returns a Tweet when quoted_status is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, quoted_status: Tweeter::Tweet.new(id: 540_897_316_908_331_009, text: "BOOSH"))
      expect(tweet.quoted_status).to be_a Tweeter::Tweet
      expect(tweet.quoted_status.not_nil!.text).to eq("BOOSH")
    end

    it "returns nil when quoted_status is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.quoted_status).to be_nil
    end
  end

  describe "#quoted_status?" do
    it "returns a true when quoted_status is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, quoted_status: Tweeter::Tweet.new(id: 540_897_316_908_331_009, text: "BOOSH"))
      expect(tweet.quoted_status?).to be_true
    end

    it "returns false when quoted_status is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.retweeted_status?).to be_false
    end
  end

  describe "#symbols" do
    it "returns an array of Entity::Symbol when symbols are set" do
      entities = Tweeter::Entities.new(symbols: [
        Tweeter::Entity::Symbol.new(text: "PEP", indices: {114, 118}),
        Tweeter::Entity::Symbol.new(text: "COKE", indices: {128, 133}),
      ])
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, entities: entities)
      expect(tweet.symbols).to be_a Array(Tweeter::Entity::Symbol)
      expect(tweet.symbols.size).to eq(2)
      expect(tweet.symbols.first).to be_a Tweeter::Entity::Symbol
      expect(tweet.symbols.first.indices).to eq({114, 118})
      expect(tweet.symbols.first.text).to eq("PEP")
    end

    it "is empty when not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.symbols.empty?).to be_true
    end
  end

  describe "#symbols?" do
    it "returns true when tweet includes symbol entities" do
      entities = Tweeter::Entities.new(symbols: [
        Tweeter::Entity::Symbol.new(text: "PEP", indices: {114, 118}),
      ])
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, entities: entities)
      expect(tweet.symbols?).to be_true
    end

    it "returns false when no entities are present" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.symbols?).to be_false
    end
  end

  describe "#uris" do
    it "returns an array of Entity::URIs when entities are set" do
      entities = Tweeter::Entities.new(
        urls: [
          Tweeter::Entity::URL.new(
            url: URI.parse("https://t.co/L2xIBazMPf"),
            expanded_url: URI.parse("http://example.com/expanded"),
            display_url: "example.com/expanded...",
            indices: {10, 33}
          ),
        ]
      )
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, entities: entities)
      expect(tweet.urls).to be_a Array(Tweeter::Entity::URL)
      expect(tweet.urls.first.indices).to eq({10, 33})
      expect(tweet.urls.first.display_url).to be "example.com/expanded..."
    end

    it "is empty when not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.urls.empty?).to be_true
    end
  end

  describe "#uri" do
    it "returns the URI to the tweet" do
      tweet = Tweeter::Tweet.new(id: 955689420035825664_i64, user: Tweeter::User.new(id: 2252786816_i64, screen_name: "_watzon"))
      expect(tweet.url).to be_a URI
      expect(tweet.url.to_s).to eq("https://twitter.com/_watzon/status/955689420035825664")
    end
  end

  describe "#uris?" do
    it "returns true when the tweet includes url entities" do
      entities = Tweeter::Entities.new(urls: [Tweeter::Entity::URL.new(url: URI.parse("https://t.co/L2xIBazMPf"))])
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, entities: entities)
      expect(tweet.urls?).to be_true
    end

    it "returns false when no entities are present" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.urls?).to be_false
    end
  end

  describe "#user" do
    it "returns a User when user is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, user: Tweeter::User.new(id: 2252786816_i64))
      expect(tweet.user).to be_a Tweeter::User
    end

    it "returns nil when user is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.user).to be_nil
    end

    pending "has a status set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, text: "Tweet text.", user: Tweeter::User.new(id: 2252786816_i64))
      user = tweet.user.not_nil!
      expect(user.status).to be_a Tweeter::Tweet
      expect(user.status.id).to eq(28669546014_i64)
    end
  end

  describe "#user?" do
    it "returns true when user is set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, user: Tweeter::User.new(id: 2252786816_i64))
      expect(tweet.user?).to be_true
    end

    it "returns false when user is not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.user?).to be_false
    end
  end

  describe "#user_mentions" do
    it "returns an array of Entity::UserMention when entities are set" do
      entities = Tweeter::Entities.new(user_mentions: [
        Tweeter::Entity::UserMention.new(
          id: 2252786816_i64,
          id_str: "2252786816",
          screen_name: "_watzon",
          name: "Chris W",
          indices: {0, 7}
        ),
      ])
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, entities: entities)
      expect(tweet.user_mentions).to be_a Array(Tweeter::Entity::UserMention)
      expect(tweet.user_mentions.first.indices).to eq({0, 7})
      expect(tweet.user_mentions.first.id).to eq(2252786816_i64)
    end

    it "is empty when not set" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.user_mentions.empty?).to be_true
    end
  end

  describe "#user_mentions?" do
    it "returns true when the tweet includes user_mention entities" do
      entities = Tweeter::Entities.new(user_mentions: [
        Tweeter::Entity::UserMention.new(
          id: 2252786816_i64,
          id_str: "2252786816",
          screen_name: "_watzon",
          name: "Chris W",
          indices: {0, 7}
        ),
      ])
      tweet = Tweeter::Tweet.new(id: 28669546014_i64, entities: entities)
      expect(tweet.user_mentions?).to be_true
    end

    it "returns false when no entities are present" do
      tweet = Tweeter::Tweet.new(id: 28669546014_i64)
      expect(tweet.user_mentions?).to be_false
    end
  end
end
