require_relative 'syntax_analyzer'

class Neutralizer
  def analyzer
    @analyzer ||= SyntaxAnalyzer.new
  end

  def generate_replacements(text)
    []
  end

  def neutralize(text)
    text
  end
end
