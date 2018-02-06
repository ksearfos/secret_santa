class SecretSanta
  class Groups
    attr_reader :members

    def initialize(people)
      @members = people.select do |person_or_group|
        person_or_group.to_s != person_or_group
      end
    end

    def empty?
      @members.empty?
    end

    def same?(person1, person2)
      return false if empty?

      group_for(person1).include?(person2)
    end

    def largest
      @members.sort_by { |group| group.size }.first
    end

    private

    def group_for(person)
      @members.find { |group| group.include?(person) } || []
    end
  end
end
