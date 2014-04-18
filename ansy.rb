#!/usr/bin/ruby

require 'yaml'
require 'pp'

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
    result = @regexp =~ line
    return result
  end
end

ruletext = <<"EOF"
- condition: "\\] DEBUG\\:"
  ansi: "\033[36m\033[1m"
- condition: "\\] INFO\\:"
  ansi: "\033[37m\033[1m"
- condition: "\\] exception\\ "
  ansi: "\033[31m\033[1m"
- condition: "\\] PHP\ Notice\\:"
  ansi: "\033[31m\033[1m"
- condition: "\\] WARN\\:"
  ansi: "\033[33m\033[1m"
- condition: "\\] PHP\\ Fatal"
  ansi: "\033[31m\033[1m"
- condition: "\\] ERROR\\:"
  ansi: "\033[31m\033[1m"
- condition: "\\] DEBUG\\:Do\\ not\\ use\\:"
  ansi: "\033[33m\033[1m"
EOF

yamlData = YAML.load(ruletext)

rules = []
yamlData.each do |y|
  pp y

  rules << ColorRule.new(y['condition'], y['ansi'])
end

pp rules

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

