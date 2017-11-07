require 'spec_helper'

describe SecretSanta do
  subject { described_class.new list }

  describe '#assignments' do
    context 'when there are not enough people to play SecretSanta' do
      let(:list) { [] }

      specify do
        expect(subject.assignments).to eq({})
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

    context 'when there are lots of players' do
      let(:list) { %w(Alice Bob Carol Dave Ethan Fran Ike Jim) }

      it 'assigns each player a secret santa' do
        expect(subject.assignments.values.all?).to be true
      end

      it 'never assigns a player to himself' do
        subject.assignments.each do |player, santa|
          expect(player).not_to eq santa
        end
      end

      it 'uses each player as a secret santa exactly once' do
        expect(subject.assignments.values).to match_array list
      end

      it 'changes assignments every time' do
        first_set = subject.assignments
        second_set = subject.assignments
        expect(first_set).not_to eq second_set
      end
    end

    context 'when some of the players are designated as a couple' do
      let(:list) { %w(Alice Bob Carol Dave Ethan Fran Ike Jim) }
      let(:couples) { [%w(Alice Bob), %w(Carol Dave)] }

      it 'does not assign members of a couple to each other' do
        expect(subject.assignments.values['Alice']).not_to eq 'Bob'
        expect(subject.assignments.values['Bob']).not_to eq 'Alice'
        expect(subject.assignments.values['Carol']).not_to eq 'Dave'
        expect(subject.assignments.values['Dave']).not_to eq 'Carol'
      end
    end
  end
end
