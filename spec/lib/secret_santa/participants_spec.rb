require 'spec_helper'

describe SecretSanta::Participants, participants: true do
  subject { described_class.new(list) }

  let(:list) { [couple1, 'Carol', 'Dave', couple2, 'Ian', 'Jim'] }
  let(:flat_list) { %w(Alice Bob Carol Dave Ethan Fran Ian Jim) }
  let(:couple1) { %w(Alice Bob) }
  let(:couple2) { %w(Ethan Fran) }

  describe '#all' do
    it 'is a flat list of all participants' do
      expect(subject.all).to eq flat_list
    end
  end

  describe '#couples' do
    it 'is a list of all couples' do
      expect(subject.couples).to eq [couple1, couple2]
    end
  end

  describe '#reorder!' do
    it 'reorders the list of participants' do
      subject.reorder!
      expect(subject.all).not_to eq flat_list
      expect(subject.all).to match_array flat_list
    end

    it 'reorders until no couples are next to each other' do
      subject.reorder!

      alice_index = subject.all.index 'Alice'
      bob_index = subject.all.index 'Bob'
      ethan_index = subject.all.index 'Ethan'
      fran_index = subject.all.index 'Fran'

      expect((alice_index - bob_index).abs).not_to eq 1
      expect((ethan_index - fran_index).abs).not_to eq 1
    end

    it 'reorders until no couples are the first and last people' do
      subject.reorder!

      first = subject.all.first
      last = subject.all.last

      expect([first, last]).not_to match_array couple1
      expect([first, last]).not_to match_array couple2
    end

    context 'when there is a couple and so few people they must get paired' do
      let(:list) { [couple1, 'Carol'] }

      it 'does not try to decouple the list' do
        expect(subject.all).to receive(:shuffle!).exactly(1).times
        subject.reorder!
      end
    end
  end

  describe '#each_group_of_two' do
    let(:list) { [1,2,3] }

    it 'iterates over each pair of items in the list' do
      expect do
        subject.each_group_of_two { |a,b| puts "#{a} #{b}" }
      end.to output("1 2\n2 3\n3 1\n").to_stdout
    end

    context 'when there is only one item in the list' do
      let(:list) { [1] }

      it 'pairs that item with itself' do
        expect do
          subject.each_group_of_two { |a,b| puts "#{a} #{b}" }
        end.to output("1 1\n").to_stdout
      end
    end

    context 'when the list is empty' do
      let(:list) { [] }

      it 'happily does nothing' do
        expect do
          subject.each_group_of_two { |a,b| puts "#{a} #{b}" }
        end.not_to output.to_stdout
      end
    end
  end
end
