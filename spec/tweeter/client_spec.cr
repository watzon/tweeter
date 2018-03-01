require "../spec_helper"

describe Tweeter::Client do
  subject { Tweeter::Client.new }

  describe "#user_agent" do
    it "defaults to Tweeter.cr/version" do
      expect(subject.user_agent).to eq("Tweeter.cr/#{Tweeter::Version.to_s}")
    end
  end

  describe "#user_agent=" do
    it "overwrites the User-Agent string" do
      subject.user_agent = "MyTwitterClient/1.0.0"
      expect(subject.user_agent).to eq("MyTwitterClient/1.0.0")
    end
  end

  describe "#user_token?" do
    it "returns true if the user token/secret are present" do
      client = Tweeter::Client.new(access_token: "AT", access_token_secret: "AS")
      expect(client.user_token?).to be_true
    end

    it "returns false if the token/secret are not completely present" do
      client = Tweeter::Client.new(access_token: "AT")
      expect(client.user_token?).to be_false
    end

    it "returns false if the token or secret is blank" do
      client = Tweeter::Client.new(access_token: "", access_token_secret: "AS")
      expect(client.user_token?).to be_false

      client = Tweeter::Client.new(access_token: "AT", access_token_secret: "")
      expect(client.user_token?).to be_false
    end
  end

  describe "#credentials" do
    it "returns true if all credentials are present" do
      client = Tweeter::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
      expect(client.credentials?).to be_true
    end

    it "returns false if any credentials are missing" do
      client = Tweeter::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT")
      expect(client.credentials?).to be_false

      client = Tweeter::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token_secret: "AS")
      expect(client.credentials?).to be_false

      client = Tweeter::Client.new(consumer_key: "CK", access_token: "AT", access_token_secret: "AS")
      expect(client.credentials?).to be_false

      client = Tweeter::Client.new(consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
      expect(client.credentials?).to be_false
    end

    it "returns false if any credential is blank" do
      client = Tweeter::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "")
      expect(client.credentials?).to be_false

      client = Tweeter::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "", access_token_secret: "AS")
      expect(client.credentials?).to be_false

      client = Tweeter::Client.new(consumer_key: "CK", consumer_secret: "", access_token: "AT", access_token_secret: "AS")
      expect(client.credentials?).to be_false

      client = Tweeter::Client.new(consumer_key: "", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
      expect(client.credentials?).to be_false
    end
  end
end
