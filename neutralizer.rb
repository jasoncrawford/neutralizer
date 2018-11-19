require_relative 'syntax_analyzer'

class Neutralizer
  def analyzer
    @analyzer ||= SyntaxAnalyzer.new
  end

  def is_gendered?(token)
    gender = token.part_of_speech.gender
    return gender == :MASCULINE || gender == :FEMININE
  end

  def neutralize_verb(text)
    case text
    when "does" then "do"
    else text
    end
  end

  def generate_replacements(text)
    # puts "TEXT: #{text}"
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
        else throw "unexpected case #{pos.case} with label #{edge.label} for token '#{text.content}' at #{text.begin_offset}"
        end
      when :POBJ, :DOBJ, :IOBJ, :GOBJ
        "Them"
      when :POSS, :PS
        "Their"
      when :ATTR
        "Theirs"
      else
        throw "unexpected label #{edge.label} for token '#{text.content}' at #{text.begin_offset}"
      end

      repl.downcase! if text.content == text.content.downcase
      # puts "replacing '#{text.content}' (#{edge.label}, #{pos.case}) with '#{repl}' at #{text.begin_offset}"
      replacements << {orig: text.content, offset: text.begin_offset, repl: repl}

      if pos.case == :NOMINATIVE
        verb = tokens[edge.head_token_index]
        vtext = verb.text
        vedge = verb.dependency_edge
        vpos = verb.part_of_speech

        # puts "need to replace '#{vtext.content}' (#{vedge.label}, #{vpos.tense}, #{vpos.mood}) for '#{text.content}' -> '#{repl}'?"
        repl = neutralize_verb vtext.content
        if repl != vtext.content
          replacements << {orig: vtext.content, offset: vtext.begin_offset, repl: repl}
        end
      end
    end

    replacements
  end

  def replace_tokens(text, replacements)
    text = text.dup
    offset = 0

    replacements.each do |r|
      first = r[:offset] + offset
      last = first + r[:orig].length - 1
      text[first..last] = r[:repl]
      offset += r[:repl].length - r[:orig].length
    end

    text
  end

  def neutralize(text)
    replacements = generate_replacements text
    replace_tokens text, replacements
  end
end
