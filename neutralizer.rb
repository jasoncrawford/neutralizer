require_relative 'syntax_analyzer'

class Neutralizer
  def analyzer
    @analyzer ||= SyntaxAnalyzer.new
  end

  def is_gendered?(token)
    gender = token.part_of_speech.gender
    return gender == :MASCULINE || gender == :FEMININE
  end

  def replacement_for_gendered_token(text, edge, pos)
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
    {orig: text.content, offset: text.begin_offset, repl: repl}
  end

  def neutralize_verb(text)
    case text
    when "is" then "are"
    when "does" then "do"
    else text.sub(/s?$/, '')
    end
  end

  def replacement_for_verb(token)
    text = token.text
    repl = neutralize_verb text.content
    if repl != text.content
      {orig: text.content, offset: text.begin_offset, repl: repl}
    end
  end

  def replacements_for_token(token, tokens)
    return [] unless is_gendered?(token)
    replacements = []

    text = token.text
    edge = token.dependency_edge
    pos = token.part_of_speech

    replacements << replacement_for_gendered_token(text, edge, pos)

    if pos.case == :NOMINATIVE
      verb = tokens[edge.head_token_index]
      replacement = replacement_for_verb verb
      replacements << replacement if replacement
    end

    replacements
  end

  def generate_replacements(text)
    # puts "TEXT: #{text}"
    analysis = analyzer.analyze text
    tokens = analysis.tokens
    tokens.map {|token| replacements_for_token token, tokens}.flatten
  end

  def replace_tokens(text, replacements)
    text = text.dup

    sorted = replacements.sort_by {|r| -r[:offset]}
    sorted.each do |r|
      first = r[:offset]
      last = first + r[:orig].length - 1
      text[first..last] = r[:repl]
    end

    text
  end

  def neutralize(text)
    replacements = generate_replacements text
    replace_tokens text, replacements
  end
end
