module BlockScore
  RSpec.describe Collection do
    let(:person) { create(:person) }
    subject(:question_sets) { person.question_sets }

    it { expect(question_sets.empty?).to be true }
    it { expect(question_sets.class).to be BlockScore::Collection }

    describe '.all' do
      it { expect(question_sets.all.empty?).to be true }
      it { expect(question_sets.all.class).to be BlockScore::Collection }
    end

    describe '.new' do
      before { question_sets.new }

      it { expect(question_sets.empty?).to be false }
      it { expect(question_sets.count).to be 1 }
      it { expect(question_sets.class).to be BlockScore::Collection }
    end

    describe '.refresh' do
      before do
        question_sets.new
        question_sets.new
        question_sets.refresh
      end

      it { expect(question_sets.empty?).to be true }
      it { expect(question_sets.class).to be BlockScore::Collection }
    end

    describe '.create' do
      before { question_sets.create }

      it { expect(question_sets.empty?).to be false }
      it { expect(question_sets.count).to be 1 }
      it { expect(question_sets.class).to be BlockScore::Collection }
    end

    describe '.retrieve' do
      let(:question_set_id) { create(:question_set, person_id: person.id).id }

      it { expect(question_sets.retrieve(question_set_id).nil?).to be false }
      it { expect(question_sets.retrieve(question_set_id).class).to be BlockScore::Collection::Member }
    end
  end
end
