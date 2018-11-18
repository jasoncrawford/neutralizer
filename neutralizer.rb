require_relative 'syntax_analyzer'

class Neutralizer
  def analyzer
    @analyzer ||= SyntaxAnalyzer.new
  end

  def generate_replacements(text)
    analysis = analyzer.analyze text
    tokens = analysis.tokens

    replacements = []
    tokens.each do |token|
      gender = token.part_of_speech.gender
      if gender == :MASCULINE || gender == :FEMININE
        replacements << {orig: "He", offset: 0, repl: "They"}
      end
    end

    replacements
  end

  def neutralize(text)
    text
  end
end
