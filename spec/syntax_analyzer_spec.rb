require_relative '../syntax_analyzer'

describe SyntaxAnalyzer do
  let(:analyzer) { SyntaxAnalyzer.new }

  it 'has a private key' do
    expect(ENV['GOOGLE_APPLICATION_PRIVATE_KEY']).to_not be_nil
  end

  describe "credentials_json" do
    subject { analyzer.credentials_json }
    it { is_expected.to be_a(Hash) }

    it "has a private key" do
      expect(subject[:private_key]).to_not be_nil
    end
  end

  describe "credentials_io" do
    subject { analyzer.credentials_io }
    it { is_expected.to be_a(StringIO) }
  end

  describe "credentials" do
    subject { analyzer.credentials }
    it { is_expected.to_not be_nil }
  end

  describe "client" do
    subject { analyzer.client }
    it { is_expected.to_not be_nil }
  end
end
