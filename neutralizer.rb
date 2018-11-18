require_relative 'syntax_analyzer'

class Neutralizer
  def analyzer
    @analyzer ||= SyntaxAnalyzer.new
  end

  def generate_replacements(text)
    analysis = analyzer.analyze text
    tokens = analysis.tokens

    token = tokens[0]
    gender = token.part_of_speech.gender
    if gender == :MASCULINE || gender == :FEMININE
      [{orig: "He", offset: 0, repl: "They"}]
    else
      []
    end
  end

  def neutralize(text)
    text
  end
end
