require_relative 'syntax_analyzer'

# General reference on syntax/grammar stuff here:
# https://cloud.google.com/natural-language/docs/morphology

class Neutralizer
  class Error < StandardError; end

  def self.instance
    @@instance ||= new
  end

  def self.neutralize(text)
    instance.neutralize text
  end

  def initialize
    puts "Neutralizer#initialize"
  end

  def analyzer
    @analyzer ||= SyntaxAnalyzer.new
  end

  def has_edge(token, label, index)
    edge = token.dependency_edge
    edge.label == label && edge.head_token_index == index
  end

  def is_gendered?(token)
    gender = token.part_of_speech.gender
    return gender == :MASCULINE || gender == :FEMININE
  end

  def neutralize_pronoun(token)
    text = token.text
    edge = token.dependency_edge
    pos = token.part_of_speech

    # special case for reflexive pronouns
    return "Themselves" if text.content =~ /self$/

    case edge.label
    when :NSUBJ, :CSUBJ, :NSUBJPASS, :CSUBJPASS, :NOMCSUBJ, :NOMCSUBJPASS
      case pos.case
      when :NOMINATIVE then "They"
      when :ACCUSATIVE, :GENITIVE then "Them"
      else raise Neutralizer::Error.new("unexpected case #{pos.case} with label #{edge.label} for token '#{text.content}' at #{text.begin_offset}")
      end
    when :POBJ, :DOBJ, :IOBJ, :GOBJ
      "Them"
    when :POSS, :PS
      "Their"
    when :ATTR
      "Theirs"
    else
      raise Neutralizer::Error.new("unexpected label #{edge.label} for token '#{text.content}' at #{text.begin_offset}")
    end
  end

  def replacement_for_gendered_token(token)
    text = token.text
    repl = neutralize_pronoun token
    repl.downcase! if text.content == text.content.downcase
    {orig: text.content, offset: text.begin_offset, repl: repl}
  end

  def verbs_to_replace_for_subject(token)
    return [] unless token.part_of_speech.case == :NOMINATIVE

    index = token.dependency_edge.head_token_index
    verb = @tokens[index]
    more_verbs = @tokens.select {|t| has_edge t, :CONJ, index}
    all_verbs = [verb] + more_verbs

    all_verbs.map do |verb|
      aux = @tokens.find {|t| has_edge t, :AUX, index}
      aux || verb
    end
  end

  def neutralize_verb(text)
    case text.downcase
    when "is" then "Are"
    when "'s" then "'re"
    when "was" then "Were"
    when "has" then "Have"
    when "does" then "Do"
    else text.sub(/s?$/, '')
    end
  end

  def replacement_for_verb(token)
    return nil if !token
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

    verbs = verbs_to_replace_for_subject token
    replacements += verbs.map {|v| replacement_for_verb v}

    replacements.compact
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
