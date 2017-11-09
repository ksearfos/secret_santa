class SecretSanta
  class Participants
    attr_reader :all, :couples

    def initialize(people)
      @all = people.flatten
      @couples = people.select do |person_or_pair|
        person_or_pair.to_s != person_or_pair
      end
    end

    def reorder!
      all.shuffle!

      while big_enough_to_avoid_couples? && has_couples?
        all.shuffle!
      end
    end

    def each_group_of_two(&action)
      all.each_with_index do |person, index|
        next_person = all[index + 1] || all.first
        yield(person, next_person)
      end
    end

    private

    def has_couples?
      return false if couples.empty?

      each_group_of_two do |person1, person2|
        return true if couples.include?([person1, person2])||
          couples.include?([person2, person1])
      end

      false
    end

    # If there are 2 people, and they are a couple, there is no way to
    #  reorder such that they are not assigned to each other
    # If there are 3 people, and two are a couple, there is no way to
    #  reorder such that one member of the couple is not assigned to the other
    def big_enough_to_avoid_couples?
      all.size >=4
    end
  end
end
