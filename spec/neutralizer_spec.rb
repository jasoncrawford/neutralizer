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

    context "Yes she is" do
      let(:text) { "Yes she is" }
      it { is_expected.to eq([{orig: "she", offset: 4, repl: "they"}]) }
    end

    context "In her project" do
      let(:text) { "In her project" }
    end

    context "I told her" do
      let(:text) { "I told her" }
      it { is_expected.to eq([{orig: "her", offset: 7, repl: "them"}])}
    end

    context "She thinks he will" do
      let(:text) { "She thinks he will" }
      let(:expected) do
        [
          {orig: "She", offset: 0, repl: "They"},
          {orig: "he", offset: 11, repl: "they"},
        ]
      end
      it { is_expected.to eq(expected)}
    end
  end

  describe "neutralize" do
    let(:text) { "He said" }
    subject { neutralizer.neutralize text }
    it { is_expected.to eql("He said") }
  end
end
