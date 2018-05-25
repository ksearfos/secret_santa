#!/usr/bin/env ruby

require_relative "lib/secret_santa"

PEOPLE = [
  %w(Kelli Terri Bryan),
  %w(Andrea Eric),
  %w(Liz Dave),
  %w(Mike Linda),
  %w(Ben Elaine),
  'Grandma',
]

SecretSanta.new(PEOPLE).assignments.each do |santa,assignee|
  puts "#{santa} is assigned to #{assignee}"
end
