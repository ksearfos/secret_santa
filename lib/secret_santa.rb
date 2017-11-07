class SecretSanta
  def initialize(players, *couples)
    @players = players
    @couples = couples
  end

  def assignments
    assignments = {}
    list = decouple(@players.shuffle)

    each_group_of_two(list) do |person1, person2|
      assignments[person1] = person2
    end

    assignments
  end

  def decouple(list)
    ordered = list

    while has_couples?(ordered)
      ordered = list.shuffle
    end

    ordered
  end

  def has_couples?(list)
    return false if @couples.empty? || list.size < 4

    each_group_of_two(list) do |person1, person2|
      return true if couple?(person1, person2)
    end

    false
  end

  def couple?(person1, person2)
    @couples.include?([person1, person2]) || @couples.include?([person2, person1])
  end

  private

  def each_group_of_two(list, &action)
    list.each_with_index do |person, index|
      person2 = list[index + 1] || list.first   # wrap to end
      action.call(person, person2)
    end
  end
end
