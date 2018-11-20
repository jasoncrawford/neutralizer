require_relative 'syntax_analyzer'

class Neutralizer
  def analyzer
    @analyzer ||= SyntaxAnalyzer.new
  end

  def is_gendered?(token)
    gender = token.part_of_speech.gender
    return gender == :MASCULINE || gender == :FEMININE
  end

  def neutralize_pronoun(token)
    text = token.text
    edge = token.dependency_edge
    pos = token.part_of_speech

    case edge.label
    when :NSUBJ, :CSUBJ, :NSUBJPASS, :CSUBJPASS, :NOMCSUBJ, :NOMCSUBJPASS
      case pos.case
      when :NOMINATIVE then "They"
      when :ACCUSATIVE then "Them"
      else raise "unexpected case #{pos.case} with label #{edge.label}"
      end
    when :POBJ, :DOBJ, :IOBJ, :GOBJ
      "Them"
    when :POSS, :PS
      "Their"
    when :ATTR
      "Theirs"
    else
      raise "unexpected label #{edge.label}"
    end
  end

  def replacement_for_gendered_token(token)
    begin
      repl = neutralize_pronoun token
      text = token.text
      repl.downcase! if text.content == text.content.downcase
      {orig: text.content, offset: text.begin_offset, repl: repl}
    rescue => error
      raise "#{error.message} for token '#{text.content}' at #{text.begin_offset}"
    end
  end

  def verb_to_replace_for_token(token)
    if token.part_of_speech.case == :NOMINATIVE
      verb = @tokens[token.dependency_edge.head_token_index]
    end
  end

  def neutralize_verb(text)
    case text.downcase
    when "is" then "Are"
    when "was" then "Were"
    when "has" then "Have"
    when "does" then "Do"
    else text.sub(/s?$/, '')
    end
  end

  def replacement_for_verb(token)
    text = token.text
    repl = neutralize_verb text.content
    repl.downcase! if text.content == text.content.downcase
    if repl != text.content
      {orig: text.content, offset: text.begin_offset, repl: repl}
    end
  end

  def replacements_for_token(token)
    return [] unless is_gendered?(token)
    replacements = []

    replacements << replacement_for_gendered_token(token)

    verb = verb_to_replace_for_token token
    replacement = replacement_for_verb verb if verb
    replacements << replacement if replacement

    replacements
  end

  def generate_replacements(text)
    analysis = analyzer.analyze text
    @tokens = analysis.tokens
    @tokens.map {|token| replacements_for_token token}.flatten
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
