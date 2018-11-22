require_relative '../neutralizer'

describe Neutralizer do
  let(:neutralizer) { Neutralizer.new }

  describe "analyzer" do
    subject { neutralizer.analyzer }
    it { is_expected.to_not be_nil }
  end

  describe "generate replacements" do
    subject { neutralizer.generate_replacements text }

    context "no gendered words" do
      let(:text) { "It is" }
      it { is_expected.to match_array([]) }
    end

    describe "parts of speech" do
      context "gendered subject" do
        let(:text) { "He said" }
        it { is_expected.to match_array([{orig: "He", offset: 0, repl: "They"}]) }
      end

      context "direct object" do
        let(:text) { "I told her" }
        it { is_expected.to match_array([{orig: "her", offset: 7, repl: "them"}])}
      end

      context "possessive" do
        let(:text) { "In her project" }
        it { is_expected.to match_array([{orig: "her", offset: 3, repl: "their"}])}
      end

      context "possessive nominal phrase" do
        let(:text) { "The credit is his" }
        it { is_expected.to match_array([{orig: "his", offset: 14, repl: "theirs"}])}
      end

      context "reflexive" do
        let(:text) { "He saw himself" }
        it { is_expected.to match_array([{orig: "He", offset: 0, repl: "They"}, {orig: "himself", offset: 7, repl: "themselves"}]) }
      end
    end

    describe "tenses" do
      context "present continuous" do
        let(:text) { "He is working" }
        it { is_expected.to match_array([{orig: "He", offset: 0, repl: "They"}, {orig: "is", offset: 3, repl: "are"}]) }
      end

      context "present continuous with adverb" do
        let(:text) { "He is still working" }
        it { is_expected.to match_array([{orig: "He", offset: 0, repl: "They"}, {orig: "is", offset: 3, repl: "are"}]) }
      end

      context "present perfect" do
        let(:text) { "She has done it" }
        it { is_expected.to match_array([{orig: "She", offset: 0, repl: "They"}, {orig: "has", offset: 4, repl: "have"}]) }
      end
    end

    describe "irregular verbs" do
      context "does" do
        let(:text) { "She does" }
        it { is_expected.to match_array([{orig: "She", offset: 0, repl: "They"}, {orig: "does", offset: 4, repl: "do"}]) }
      end

      context "is" do
        let(:text) { "Yes she is" }
        it { is_expected.to match_array([{orig: "she", offset: 4, repl: "they"}, {orig: "is", offset: 8, repl: "are"}]) }
      end

      context "was" do
        let(:text) { "He was there" }
        it { is_expected.to match_array([{orig: "He", offset: 0, repl: "They"}, {orig: "was", offset: 3, repl: "were"}]) }
      end

      context "has" do
        let(:text) { "She has the skills" }
        it { is_expected.to match_array([{orig: "She", offset: 0, repl: "They"}, {orig: "has", offset: 4, repl: "have"}]) }
      end
    end

    describe "more complicated cases" do
      context "two subjects" do
        let(:text) { "She thinks he will" }
        let(:expected) do
          [
            {orig: "She", offset: 0, repl: "They"},
            {orig: "thinks", offset: 4, repl: "think"},
            {orig: "he", offset: 11, repl: "they"},
          ]
        end
        it { is_expected.to match_array(expected) }
      end

      context "two verbs" do
        let(:text) { "She likes the work and wants to do more" }
        let(:expected) do
        end
        it { is_expected.to include(*[]) }
      end

      context "several gendered words combined" do
        let(:text) { "He wants her to know that she can join his team" }
        let(:expected) do
          [
            {orig: "He", offset: 0, repl: "They"},
            {orig: "wants", offset: 3, repl: "want"},
            {orig: "her", offset: 9, repl: "them"},
            {orig: "she", offset: 26, repl: "they"},
            {orig: "his", offset: 39, repl: "their"},
          ]
        end
        it { is_expected.to match_array(expected) }
      end

      context "two forms of 'her'" do
        let(:text) { "I gave her back her pen" }
        it { is_expected.to match_array([{orig: "her", offset: 7, repl: "them"}, {orig: "her", offset: 16, repl: "their"}]) }
      end
    end

    describe "contractions" do
      context "'s" do
        let(:text) { "He's the one" }
        it { is_expected.to match_array([{orig: "He", offset: 0, repl: "They"}, {orig: "'s", offset: 2, repl: "'re"}]) }
      end

      context "isn't" do
        let(:text) { "She isn't ready" }
        it { is_expected.to match_array([{orig: "She", offset: 0, repl: "They"}, {orig: "is", offset: 4, repl: "are"}]) }
      end

      context "'ll" do
        let(:text) { "He'll be there" }
        it { is_expected.to match_array([{orig: "He", offset: 0, repl: "They"}]) }
      end

      context "won't" do
        let(:text) { "She won't do it" }
        it { is_expected.to match_array([{orig: "She", offset: 0, repl: "They"}]) }
      end

      context "wasn't" do
        let(:text) { "He wasn't wrong" }
        it { is_expected.to match_array([{orig: "He", offset: 0, repl: "They"}, {orig: "was", offset: 3, repl: "were"}]) }
      end
    end

    describe "special cases" do
      context "question" do
        let(:text) { "Is he smart?" }
        it { is_expected.to match_array([{orig: "Is", offset: 0, repl: "Are"}, {orig: "he", offset: 3, repl: "they"}]) }
      end
    end
  end

  describe "replace tokens" do
    subject { neutralizer.replace_tokens text, replacements }

    context "no gendered words" do
      let(:text) { "It is" }
      let(:replacements) { [] }
      it { is_expected.to eq(text) }
    end

    context "one gendered word" do
      let(:text) { "He said" }
      let(:replacements) { [{orig: "He", offset: 0, repl: "They"}] }
      it { is_expected.to eq("They said") }
    end

    context "multiple gendered words" do
      let(:text) { "She thinks he will" }
      let(:replacements) do
        [
          {orig: "She", offset: 0, repl: "They"},
          {orig: "thinks", offset: 4, repl: "think"},
          {orig: "he", offset: 11, repl: "they"},
        ]
      end
      it { is_expected.to eq("They think they will") }
    end
  end

  describe "neutralize" do
    subject { neutralizer.neutralize text }

    context "no gendered words" do
      let(:text) { "It is" }
      it { is_expected.to eql("It is") }
    end

    context "one gendered word" do
      let(:text) { "He said" }
      it { is_expected.to eq("They said") }
    end

    context "multiple gendered words" do
      let(:text) { "I gave her back her pen" }
      it { is_expected.to eq("I gave them back their pen") }
    end
  end
end
