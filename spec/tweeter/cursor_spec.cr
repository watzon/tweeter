require "../spec_helper"

describe Tweeter::Cursor do
  describe "#each" do
    let!(client) { Tweeter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS") }

    before do
      stub_get("/1.1/followers/ids.json?screen_name=_watzon&cursor=-1").to_return(body: fixture("ids_list.json"), headers: HTTP::Headers{"Content-Type" => "application/json; charset=utf-8"})
      stub_get("/1.1/followers/ids.json?cursor=1305102810874389703&screen_name=_watzon").to_return(body: fixture("ids_list2.json"), headers: HTTP::Headers{"Content-Type" => "application/json; charset=utf-8"})
    end

    pending "requests the correct resources" do
      client.follower_ids("_watzon").each { }
    end

    it "iterates" do
      count = 0
      client.follower_ids("_watzon").each { count += 1 }
      expect(count).to eq(6)
    end
  end
end
