RSpec.describe BlockScore::Person do
  describe '.new' do
    subject(:person) { described_class.new(attributes_for(:person)) }

    it { is_expected.not_to be_persisted }
    it { is_expected.to be_an_instance_of described_class }

    it 'creates question sets collection' do
      expect(person.question_sets).to be_an_instance_of BlockScore::Collection
    end

    it 'has a question_set with proper member_class' do
      expect(person.question_sets.new).to be_an_instance_of BlockScore::Collection::Member
    end

    it 'is setup from the options provided' do
      expect(person.name_first).to_not be_empty
    end
  end

  describe '.create' do
    context 'valid person' do
      subject(:person) { described_class.create(attributes_for(:person)) }

      it { is_expected.to be_persisted }
      it { is_expected.to be_an_instance_of described_class }
    end

    context 'invalid person' do
      subject(:person) do
        described_class.create(attributes_for(:invalid_person))
      end

      it { is_expected.to be_persisted }
      it { is_expected.to be_an_instance_of described_class }
    end
  end

  describe '#valid?' do
    context 'valid person' do
      subject(:person) { create(:valid_person) }

      it { is_expected.to be_persisted }
      it { is_expected.to be_valid }
      it { is_expected.to be_an_instance_of described_class }
    end

    context 'invalid person' do
      subject(:person) { create(:invalid_person) }

      it { is_expected.to be_persisted }
      it { is_expected.not_to be_valid }
      it { is_expected.to be_an_instance_of described_class }
    end
  end

  describe '#invalid?' do
    context 'valid person' do
      subject(:person) { create(:valid_person) }

      it { is_expected.to be_persisted }
      it { is_expected.not_to be_invalid }
      it { is_expected.to be_an_instance_of described_class }
    end

    context 'invalid person' do
      subject(:person) { create(:invalid_person) }

      it { is_expected.to be_persisted }
      it { is_expected.to be_invalid }
      it { is_expected.to be_an_instance_of described_class }
    end
  end

  describe '#delete' do
    subject(:person) { create(:person) }
    it { expect { person.delete }.to raise_error NoMethodError }
  end

  describe '#save' do
    subject(:person) { build(:person) }
    before { person.save }

    it { is_expected.to be_persisted }
    it { is_expected.to be_an_instance_of described_class }
  end
end
