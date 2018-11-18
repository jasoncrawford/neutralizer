require_relative '../neutralizer'

describe Neutralizer do
  let(:neutralizer) { Neutralizer.new }

  describe "neutralize" do
    let(:text) { "foo" }
    subject { neutralizer.neutralize text }
    it { is_expected.to eql("foo") }
  end
end
