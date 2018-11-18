require_relative 'syntax_analyzer'

class Neutralizer
  def analyzer
    @analyzer ||= SyntaxAnalyzer.new
  end

  def neutralize(text)
    analysis = analyzer.analyze text
    text
  end
end
