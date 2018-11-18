require 'google/cloud/language'
require_relative 'syntax_analyzer'

class Neutralizer
  def analyzer
    SyntaxAnalyzer.new
  end

  def neutralize(text)
    text
  end
end
