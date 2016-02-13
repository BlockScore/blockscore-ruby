RSpec.describe BlockScore::Collection do
  let(:person) { create(:person) }
  subject(:question_sets) { person.question_sets }

  it { is_expected.to be_empty }
  it { is_expected.to be_an_instance_of described_class }

  describe '#all' do
    it { is_expected.to be_empty }
    it { expect(question_sets).to be_an_instance_of described_class }
  end

  describe '#new' do
    before { question_sets.new }

    it { is_expected.not_to be_empty }
    its(:count) { should be 1 }
    it { is_expected.to be_an_instance_of described_class }
  end

  describe '#refresh' do
    before do
      question_sets.new
      question_sets.new
      question_sets.refresh
    end

    it { is_expected.to be_empty }
    it { is_expected.to be_an_instance_of described_class }
  end

  describe '#create' do
    before { question_sets.create }

    it { is_expected.not_to be_empty }
    its(:count) { should be 1 }
    it { is_expected.to be_an_instance_of described_class }
  end

  describe '#retrieve' do
    let(:question_set_id) { create(:question_set, person_id: person.id).id }
    let(:question_set_id2) { create(:question_set, person_id: person.id).id }

    it 'is the proper class' do
      expect(question_sets.retrieve(question_set_id))
        .to be_an_instance_of BlockScore::Collection::Member
      expect(question_sets.retrieve(question_set_id))
        .to be_an_instance_of BlockScore::Collection::Member
      expect(question_sets.count).to equal(1)

      expect(question_sets.retrieve(question_set_id2))
        .to be_an_instance_of BlockScore::Collection::Member
      expect(question_sets.retrieve(question_set_id2).id)
        .to eql question_set_id2.dup
      expect(question_sets.count).to equal(2)
    end
  end
end
