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

  describe "client" do
    subject { analyzer.client }
    it { is_expected.to_not be_nil }
  end

  describe "analyze" do
    let(:text) { "This is a test" }
    let(:response) { analyzer.analyze text }
    subject { response }
    it { is_expected.to_not be_nil }

    it "has four tokens" do
      expect(subject.tokens.length).to eq(4)
    end
  end
end
