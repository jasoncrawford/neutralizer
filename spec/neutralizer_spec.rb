require_relative '../neutralizer'

describe Neutralizer do
  let(:neutralizer) { Neutralizer.new }

  describe "analyzer" do
    subject { neutralizer.analyzer }
    it { is_expected.to_not be_nil }
  end

  describe "generate replacements" do
    subject { neutralizer.generate_replacements text }

    context "It is" do
      let(:text) { "It is" }
      it { is_expected.to eq([]) }
    end

    context "He said" do
      let(:text) { "He said" }
      it { is_expected.to eq([{orig: "He", offset: 0, repl: "They"}]) }
    end

    context "She does" do
      let(:text) { "She does" }
      it { is_expected.to eq([{orig: "She", offset: 0, repl: "They"}]) }
    end
  end

  describe "neutralize" do
    let(:text) { "He said" }
    subject { neutralizer.neutralize text }
    it { is_expected.to eql("He said") }
  end
end
