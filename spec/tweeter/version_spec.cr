require "../spec_helper"

describe "Tweeter::Version" do
  describe ".to_h" do
    it "returns a hash with the right values" do
      expect(Tweeter::Version.to_h).to be_a(Hash(String, Int32?))
      expect(Tweeter::Version.to_h["major"]).to be_a(Int32)
      expect(Tweeter::Version.to_h["minor"]).to be_a(Int32)
      expect(Tweeter::Version.to_h["patch"]).to be_a(Int32)
      expect(Tweeter::Version.to_h["pre"]).to be_a(Nil)
    end
  end
end
