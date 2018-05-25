require 'spec_helper'

describe SecretSanta do
  subject { described_class.new list }

  let(:list) { [group1, 'Carol', 'Dave', group2, 'Ian', 'Jim'] }
  let(:group1) { %w(Alice Bob) }
  let(:group2) { %w(Ethan Fran Greg) }

  describe '#assignments', assignments: true do
    context 'when there are not enough people to play SecretSanta' do
      let(:list) { [] }

      specify do
        expect(described_class.new(list).assignments).to be_empty
      end
    end

    context 'when there are two players' do
      let(:list) { %w(Alice Bob) }

      it 'assigns player1 to player2' do
        expect(subject.assignments['Alice']).to eq 'Bob'
      end

      it 'assigns player2 to player1' do
        expect(subject.assignments['Bob']).to eq 'Alice'
      end
    end

    it 'assigns each player a secret santa' do
      expect(subject.assignments.values.all?).to be true
    end

    it 'never assigns a player to himself' do
      subject.assignments.each do |player, santa|
        expect(player).not_to eq santa
      end
    end

    it 'uses each player as a secret santa exactly once' do
      expect(subject.assignments.values).to match_array list.flatten
    end

    it 'changes assignments every time' do
      first_set = subject.assignments
      second_set = subject.assignments
      expect(first_set).not_to eq second_set
    end

    context 'when some of the players are designated as a couple' do
      let(:assignments) { subject.assignments }

      it 'does not assign members of a couple to each other' do
        expect(assignments['Alice']).not_to eq 'Bob'
        expect(assignments['Bob']).not_to eq 'Alice'
      end
    end

    context 'when some of the players are designated as a large group' do
      let(:assignments) { subject.assignments }

      it 'does not assign members of a group to each other' do
        expect(assignments['Ethan']).not_to eq 'Fran'
        expect(assignments['Ethan']).not_to eq 'Greg'
        expect(assignments['Fran']).not_to eq 'Ethan'
        expect(assignments['Fran']).not_to eq 'Greg'
        expect(assignments['Greg']).not_to eq 'Ethan'
        expect(assignments['Greg']).not_to eq 'Fran'
      end
    end
  end
end
