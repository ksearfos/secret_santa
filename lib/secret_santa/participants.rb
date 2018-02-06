class SecretSanta
  class Participants
    attr_reader :all, :groups

    def initialize(people)
      @all = people.flatten
      @groups = SecretSanta::Groups.new(people)
    end

    def reorder!
      all.shuffle!

      while has_groups? && big_enough_to_avoid_groups?
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

    def has_groups?
      return false if groups.empty?

      each_group_of_two do |person1, person2|
        return true if groups.same?(person1, person2)
      end

      false
    end

    def big_enough_to_avoid_groups?
      all.size >= groups.largest.size * 2
    end
  end
end
