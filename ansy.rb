#!/usr/bin/ruby

class Ansi
end

class ColorRule
  attr_accessor :sequence

  def initialize(regexp, sequence)
    @regexp = Regexp.new(regexp)
    @sequence = sequence
    @clear = "\033[0m"
  end

  def check(line)
    return @regexp =~ line
  end
end

rules = []
rules << ColorRule.new('\] DEBUG\:', "\033[36m\033[1m")
rules << ColorRule.new("\\] INFO\:", "\033[37m\033[1m")
rules << ColorRule.new("\\] exception\ ", "\033[31m\033[1m")
rules << ColorRule.new("\\] PHP\ Notice\:", "\033[31m\033[1m")
rules << ColorRule.new("\\] WARN\:", "\033[33m\033[1m")
rules << ColorRule.new("\\] PHP\ Fatal", "\033[31m\033[1m")
rules << ColorRule.new("\\] ERROR\:", "\033[31m\033[1m")
rules << ColorRule.new("\\] DEBUG\\:Do\\ not\\ use\\:", "\033[33m\033[1m")

escape = ''
while line = STDIN.gets do
  line.chop

  rules.each do |rule|
    if rule.check(line) then
      escape = rule.sequence
    end
  end
  if !escape.empty? then
    line = escape + line + "\033[0m"
  end

  print line
end

