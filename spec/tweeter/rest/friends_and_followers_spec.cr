require "../../spec_helper"

describe Tweeter::REST::FriendsAndFollowers do
  let(client) { Tweeter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS") }

  before do
    stub_get("/1.1/friends/ids.json?screen_name=_watzon&cursor=-1").to_return(body: fixture("ids_list.json"), headers: HTTP::Headers{"Content-Type" => "application/json; charset=utf-8"})
    stub_get("/1.1/friends/ids.json?cursor=1305102810874389703&screen_name=_watzon").to_return(body: fixture("ids_list2.json"), headers: HTTP::Headers{"Content-Type" => "application/json; charset=utf-8"})
  end

  describe "#friend_ids" do
    it "returns an array of numeric IDs for every user the specified user is following" do
      friends = client.friend_ids("_watzon")
      expect(friends).to be_a Tweeter::Cursor(Int64)
      expect(friends.first).to eq(20009713_i64)
    end
  end
end
