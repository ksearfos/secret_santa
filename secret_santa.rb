#!/usr/bin/env ruby

require_relative "lib/secret_santa"

PEOPLE = [
  %w(Kelli Terri Bryan Andrea Eric),
  ['Liz', 'Dave', 'Uncle Mike', 'Linda', 'Ben', 'Emily'),
  'Grandma',
  "Kelli's Friend Mike",
]

SecretSanta.new(PEOPLE).assignments.each do |santa,assignee|
  puts "#{santa} is getting a gift for #{assignee}"
end
