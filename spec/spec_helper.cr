require "webmock"
require "timecop"
require "spec2"
require "../src/tweeter"

include Spec2::GlobalDSL
# include Mocks::Macro

Spec2.doc

def stub_delete(path)
  stub_request(:delete, Tweeter::REST::Request::BASE_URL + path)
end

def stub_get(path)
  stub_request(:get, Tweeter::REST::Request::BASE_URL + path)
end

def stub_post(path)
  stub_request(:post, Tweeter::REST::Request::BASE_URL + path)
end

def stub_put(path)
  stub_request(:put, Tweeter::REST::Request::BASE_URL + path)
end

def stub_request(method, path)
  WebMock.stub(method, path)
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.read(fixture_path + "/" + file)
end
