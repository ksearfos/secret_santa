require 'spec_helper'

describe SecretSanta do
  subject { described_class.new list }

  describe '#assignments', assignments: true do
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
      subject { described_class.new list, couple1, couple2 }

      let(:list) { %w(Alice Bob Carol Dave Ethan Fran Ike Jim) }
      let(:couple1) { %w(Alice Bob) }
      let(:couple2) { %w(Carol Dave) }
      let(:assignments) { subject.assignments }

      it 'does not assign members of a couple to each other' do
        expect(subject.has_couples?(assignments)).to be false
      end
    end
  end

  describe '#decouple', decouple: true do
    subject { described_class.new list, couple }

    let(:list) { %w(Alice Bob Carol Ethan) }
    let(:couple) { %w(Alice Bob) }

    context 'when there are no designated couples' do
      subject { described_class.new list }

      it 'returns the list in its given order' do
        expect(subject.decouple(list)).to eq list
      end
    end

    context 'when the list is so small it cannot NOT have a couple' do
      let(:list) { %w(Alice Bob Carol) }

      it 'returns the list in its given order' do
        expect(subject.decouple(list)).to eq list
      end
    end

    context 'when the list is ordered such that a couple is together' do
      let(:decoupled) { subject.decouple(list) }

      it 'changes the order of the list' do
        expect(decoupled).not_to eq list
      end

      it 'changes the order such that couples are not together' do
        expect(subject.has_couples?(decoupled)).to be false
      end
    end

    context 'when the list is ordered such that a couple is the first and last items' do
      let(:decoupled) { subject.decouple(list) }

      it 'changes the order of the list' do
        expect(decoupled).not_to eq list
      end

      it 'changes the order such that couples are not together' do
        expect(subject.has_couples?(decoupled)).to be false
      end
    end

    context 'when the list is ordered such that no couples are together' do
      let(:list) { %w(Alice Carol Bob Ethan) }

      it 'returns the list in its given order' do
        expect(subject.decouple(list)).to eq list
      end
    end
  end

  describe '#couple?', couple: true do
    subject { described_class.new list, couple }

    let(:list) { %w(Alice Bob Carol Ethan) }
    let(:couple) { %w(Alice Bob) }

    context 'when the pair has been defined as a couple' do
      specify do
        expect(subject.couple?('Alice', 'Bob')).to be true
      end

      context 'in any order' do
        specify do
          expect(subject.couple?('Bob', 'Alice')).to be true
        end
      end
    end

    context 'when the pair has not been defined as a couple' do
      specify do
        expect(subject.couple?('Alice', 'Carole')).to be false
      end
    end
  end

  describe '#has_couples?', has_couples: true do
    subject { described_class.new list, couple }

    let(:list) { %w(Alice Bob Carol Ethan) }
    let(:couple) { %w(Alice Bob) }

    context 'when there are no designated couples' do
      subject { described_class.new list }

      specify do
        expect(subject.has_couples?(['Alice', 'Bob'])).to be false
      end
    end

    context 'when the list is so small it cannot NOT have a couple' do
      specify do
        expect(subject.has_couples?(['Alice', 'Bob'])).to be false
      end
    end

    context 'when the list is ordered such that a couple is together' do
      specify do
        expect(subject.has_couples?(%w(Carol Bob Alice Ethan))).to be true
      end
    end

    context 'when the list is ordered such that a couple is the first and last items' do
      specify do
        expect(subject.has_couples?(%w(Bob Carol Ethan Alice))).to be true
      end
    end

    context 'when the list is ordered such that no couples are together' do
      specify do
        expect(subject.has_couples?(%w(Bob Carol Alice Ethan))).to be false
      end
    end
  end
end
