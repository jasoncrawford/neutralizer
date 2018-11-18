require_relative '../syntax_analyzer'

describe SyntaxAnalyzer do
  let(:analyzer) { SyntaxAnalyzer.new }

  describe "credentials_json" do
    subject { analyzer.credentials_json }
    it { is_expected.to be_a(Hash) }
  end

  describe "credentials_io" do
    subject { analyzer.credentials_io }
    it { is_expected.to be_nil }
  end

  describe "credentials" do
    subject { analyzer.credentials }
    it { is_expected.to_not be_nil }
  end

  describe "client" do
    subject { analyzer.client }
  end
end
