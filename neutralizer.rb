require_relative 'syntax_analyzer'

class Neutralizer
  def analyzer
    @analyzer ||= SyntaxAnalyzer.new
  end

  def generate_replacements
  end

  def neutralize(text)
    analysis = analyzer.analyze text
    tokens = analysis.tokens
    text
  end
end
