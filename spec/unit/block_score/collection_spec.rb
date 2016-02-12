RSpec.describe BlockScore::Collection do
  let(:person) { create(:person) }
  subject(:question_sets) { person.question_sets }

  it { is_expected.to be_empty }
  its(:class) { should be described_class }

  describe '.all' do
    it { is_expected.to be_empty }
    it { expect(question_sets.all.class).to be described_class }
  end

  describe '.new' do
    before { question_sets.new }

    it { is_expected.not_to be_empty }
    its(:count) { should be 1 }
    its(:class) { should be described_class }
  end

  describe '.refresh' do
    before do
      question_sets.new
      question_sets.new
      question_sets.refresh
    end

    it { is_expected.to be_empty }
    its(:class) { should be described_class }
  end

  describe '.create' do
    before { question_sets.create }

    it { is_expected.not_to be_empty }
    its(:count) { should be 1 }
    its(:class) { should be described_class }
  end

  describe '.retrieve' do
    let(:question_set_id) { create(:question_set, person_id: person.id).id }

    it { expect(question_sets.retrieve(question_set_id).class).to be BlockScore::Collection::Member }
  end
end
