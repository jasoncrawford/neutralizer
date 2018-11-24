require_relative '../syntax_analyzer'

describe SyntaxAnalyzer do
  let(:analyzer) { SyntaxAnalyzer.new }

  it 'has a private key' do
    expect(ENV['GOOGLE_APPLICATION_PRIVATE_KEY']).to_not be_nil
  end

  describe "credentials" do
    subject { analyzer.credentials }
    it { is_expected.to be_a(Hash) }

    it "has a private key" do
      expect(subject[:private_key]).to_not be_nil
    end
  end

  describe "analyze" do
    let(:response) { analyzer.analyze text }
    subject { response }

    context "with normal input" do
      let(:text) { "This is a test" }
      it { is_expected.to_not be_nil }

      it "has four tokens" do
        expect(subject.tokens.length).to eq(4)
      end

      describe "each token" do
        subject { response.tokens[0] }

        it "has text content" do
          expect(subject.text.content).to eq("This")
        end

        it "has text begin offset" do
          expect(subject.text.begin_offset).to eq(0)
        end

        it "has dependency edge label" do
          expect(subject.dependency_edge.label).to eq(:NSUBJ)
        end
      end
    end

    describe "special characters" do
      context "multiple special characters" do
        let(:text) { "Won’t you handle “special” characters—please?" }
        it("does not error") { expect{subject}.not_to raise_error }
      end
    end
  end
end
