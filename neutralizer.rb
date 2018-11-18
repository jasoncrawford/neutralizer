require_relative 'syntax_analyzer'

class Neutralizer
  def analyzer
    @analyzer ||= SyntaxAnalyzer.new
  end

  def is_gendered?(token)
    gender = token.part_of_speech.gender
    return gender == :MASCULINE || gender == :FEMININE
  end

  def generate_replacements(text)
    analysis = analyzer.analyze text
    tokens = analysis.tokens

    replacements = []
    tokens.each do |token|
      next unless is_gendered?(token)
      text = token.text
      edge = token.dependency_edge

      repl = case edge.label
      when :NSUBJ
        "They"
      when :DOBJ
        "Them"
      when :POSS
        "Their"
      when :ATTR
        "Theirs"
      else
        "They"
      end

      repl.downcase! if text.content == text.content.downcase
      replacements << {orig: text.content, offset: text.begin_offset, repl: repl}
    end

    replacements
  end

  def neutralize(text)
    text
  end
end
