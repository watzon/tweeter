require "../spec_helper"

describe "Style" do
  it "code should be formatted correctly (crystal tool format)" do
    result = system("crystal tool format --check")
    expect(result).to be_true
  end
end
