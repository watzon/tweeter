require "../spec_helper"

describe "Style" do
  it "code should be formatted correctly (crystal tool format)" do
    dir = ENV["TRAVIS_BUILD_DIR"]? ? ENV["TRAVIS_BUILD_DIR"] + "/{src,spec}" : "./{src,spec}"
    result = system("crystal tool format #{dir} --check")
    expect(result).to be_true
  end
end
