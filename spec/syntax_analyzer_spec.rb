require_relative '../syntax_analyzer'

describe SyntaxAnalyzer do
  let(:analyzer) { SyntaxAnalyzer.new }

  describe "credentials" do
    subject { analyzer.credentials }
    it { is_expected.to be_nil }
  end

  describe "client" do
    subject { analyzer.client }
  end
end
