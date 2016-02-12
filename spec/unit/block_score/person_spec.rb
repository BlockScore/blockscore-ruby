RSpec.describe BlockScore::Person do
  describe '.new' do
    subject(:person) { described_class.new(attributes_for(:person)) }

    it { is_expected.not_to be_persisted }
    it { is_expected.to be_an_instance_of described_class }
  end

  describe '.create' do
    context 'valid person' do
      subject(:person) { described_class.create(attributes_for(:person)) }

      it { is_expected.to be_persisted }
      it { is_expected.to be_an_instance_of described_class }
    end

    context 'invalid person' do
      subject(:person) { described_class.create(attributes_for(:invalid_person)) }

      it { is_expected.to be_persisted }
      it { is_expected.to be_an_instance_of described_class }
    end
  end

  describe '.retrieve' do
    let(:person_id) { create(:person).id }
    subject(:person) { described_class.retrieve(person_id) }

    it { is_expected.to be_persisted }
    its(:name_first) { is_expected.not_to be_empty }
    it { is_expected.to be_an_instance_of described_class }
    context 'null id presented' do
      let(:person_id) { nil }

      it { expect { described_class.retrieve(person_id) }.to raise_error(ArgumentError, 'ID must be supplied') }
    end

    context 'empty id presented' do
      let(:person_id) { '' }

      it { expect { described_class.retrieve(person_id) }.to raise_error(ArgumentError, 'ID must be supplied') }
    end

    context 'Malformed ID presented' do
      let(:person_id) { 'ABC&&234' }

      it { expect { described_class.retrieve(person_id) }.to raise_error(ArgumentError, 'ID is malformed') }
    end
  end

  describe '.all' do
    let(:uniq_token_one) { '4c2c019a1e3c33442644d9f52c7a93f7' }
    let(:uniq_token_two) { 'b19a680671c6c006c6105aa450837668' }
    subject(:people) { described_class.all }

    before do
      create(:person, name_first: 'John', name_last: uniq_token_one)
      create(:person, name_first: 'John', name_last: uniq_token_two)
    end

    it { is_expected.not_to be_empty }
    it { expect(people[0].name_last).to eql uniq_token_two }
    it { expect(people[1].name_last).to eql uniq_token_one }
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
