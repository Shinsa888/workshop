#!/usr/bin/env ruby

if ARGV.size < 2
  puts("Usage: #{$0} DIRECTORY TYPE [QUESTION]")
  puts(" e.g.: #{$0} 2016-06-09 beginner")
  puts(" e.g.: #{$0} 2016-06-09 beginner motivation")
  exit(false)
end

require "yaml"

directory = ARGV.shift
type = ARGV.shift
target_question = ARGV.shift

questionnaires = {}
Dir.glob("#{directory}/#{type}-*.yaml").sort.each do |yaml|
  if File.basename(yaml) =~ /#{type}-(.+)\.yaml/
    account = $1
    begin
      questionnaires[account] = YAML.load(File.read(yaml, encoding: 'BOM|UTF-8'))
    rescue Psych::SyntaxError
      puts("#{account}: syntax error: #{$!}")
    end
  end
end

_, key_questionnairy = questionnaires.first
key_questionnairy["questions"].each do |question, _|
  unless target_question.nil?
    next unless question == target_question
  end

  puts("-" * question.size)
  puts(question)
  puts("-" * question.size)
  questionnaires.each do |account, questionnairy|
    answer = questionnairy["questions"][question]
    if answer.is_a?(Array)
      puts("#{account}:")
      puts(answer.join("\n"))
    else
      puts("#{account}: #{answer}")
    end
    puts("=" * 40)
  end
  puts
end
