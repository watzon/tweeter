require "../spec_helper"

describe "Style" do
  it "code should be formatted correctly (crystal tool format)" do
    root = ENV["TRAVIS_BUILD_DIR"]? ? ENV["TRAVIS_BUILD_DIR"] : "./"
    src = system("crystal tool format #{root}/src --check")
    spec = system("crystal tool format #{root}/spec --check")
    expect(src).to be_true
    expect(spec).to be_true
  end
end
