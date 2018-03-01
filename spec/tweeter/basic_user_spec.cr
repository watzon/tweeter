require "../spec_helper"

describe Tweeter::BasicUser do
  describe "#==" do
    it "returns true when object IDs are the same" do
      user = Tweeter::BasicUser.new(id: 1, screen_name: "foo")
      other = Tweeter::BasicUser.new(id: 1, screen_name: "bar")
      expect(user == other).to be_true
    end

    it "returns false when object IDs are different" do
      user = Tweeter::BasicUser.new(id: 1)
      other = Tweeter::BasicUser.new(id: 2)
      expect(user == other).to be_false
    end

    it "returns false when classes are different" do
      user = Tweeter::BasicUser.new(id: 1)
      other = Tweeter::Identity.new(id: 1)
      expect(user == other).to be_false
    end
  end
end
