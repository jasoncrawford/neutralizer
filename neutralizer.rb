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
    puts "TEXT: #{text}"
    analysis = analyzer.analyze text
    tokens = analysis.tokens

    replacements = []
    tokens.each do |token|
      next unless is_gendered?(token)
      text = token.text
      edge = token.dependency_edge
      pos = token.part_of_speech

      repl = case edge.label
      when :NSUBJ, :CSUBJ, :NSUBJPASS, :CSUBJPASS, :NOMCSUBJ, :NOMCSUBJPASS
        case pos.case
        when :NOMINATIVE then "They"
        when :ACCUSATIVE then "Them"
        else throw "unknown case #{pos.case} with label #{edge.label} for token '#{text.content}' at #{text.begin_offset}"
        end
      when :POBJ, :DOBJ, :IOBJ, :GOBJ
        "Them"
      when :POSS, :PS
        "Their"
      when :ATTR
        "Theirs"
      else
        throw "unknown label #{edge.label} for token '#{text.content}' at #{text.begin_offset}"
      end

      repl.downcase! if text.content == text.content.downcase
      puts "replacing '#{text.content}' (#{edge.label}, #{pos.case}) with '#{repl}' at #{text.begin_offset}"
      replacements << {orig: text.content, offset: text.begin_offset, repl: repl}
    end

    replacements
  end

  def replace_tokens(text, replacements)
    text = text.dup
    replacement = replacements[0]
    if replacement
      first = replacement[:offset]
      last = first + replacement[:orig].length
    end
    text
  end

  def neutralize(text)
    text
  end
end
