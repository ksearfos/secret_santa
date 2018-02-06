require_relative 'secret_santa/groups'
require_relative 'secret_santa/participants'

class SecretSanta
  def initialize(players)
    @players = Participants.new(players)
  end

  def assignments
    assignments = {}
    @players.reorder!

    @players.each_group_of_two do |person1, person2|
      assignments[person1] = person2
    end

    assignments
  end
end
