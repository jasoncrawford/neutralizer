require_relative '../neutralizer'

describe Neutralizer do
  let(:neutralizer) { Neutralizer.new }

  describe "analyze" do
    let(:text) { "foo" }
    subject { neutralizer.analyze text }
    it { is_expected.to eql("foo") }
  end

  describe "neutralize" do
    let(:text) { "foo" }
    subject { neutralizer.neutralize text }
    it { is_expected.to eql("foo") }
  end
end
