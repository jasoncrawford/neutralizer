require_relative '../neutralizer'

describe Neutralizer do
  describe "neutralize" do
    let(:text) { "foo" }
    let(:neutralizer) { Neutralizer.new }
    subject { neutralizer.neutralize text }
    it { is_expected.to eql("foo") }
  end
end
