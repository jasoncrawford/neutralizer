require_relative '../neutralizer'

describe Neutralizer do
  let(:neutralizer) { Neutralizer.new }

  describe "analyzer" do
    subject { neutralizer.analyzer }
    it { is_expected.to_not be_nil }
  end

  describe "neutralize" do
    let(:text) { "He said" }
    subject { neutralizer.neutralize text }
    it { is_expected.to eql("He said") }
  end
end
