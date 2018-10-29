#!/usr/bin/env ruby

require_relative "lib/secret_santa"

PEOPLE = [
  %w(Kelli Terri Bryan Andrea Eric),
  %w(Liz Dave Mike Linda Ben Emily),
  'Grandma',
  "Kelli's +1",
]

SecretSanta.new(PEOPLE).assignments.each do |santa,assignee|
  puts "#{santa} is assigned to #{assignee}"
end
