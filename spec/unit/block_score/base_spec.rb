require 'faker'

RSpec.describe BlockScore::Base, vcr: true do
  describe '#save' do
    context 'when creating a new candidate' do
      subject(:candidate) { build(:candidate) }
      before { candidate.save }

      its(:persisted?) { is_expected.to be true }
      its(:name_first) { is_expected.not_to be_empty }
    end

    context 'when updating an existing candidate' do
      subject(:candidate) { create(:candidate, name_first: 'John') }
      before do
        candidate.name_first = 'Jane'
        expect(candidate.save).to be true
      end

      its(:persisted?) { is_expected.to be true }
      its(:name_first) { is_expected.to eql 'Jane' }
    end

    context 'when encountering a deleted item' do
      subject(:candidate) { create(:candidate, name_first: 'John') }

      it 'is false when previously deleted' do
        candidate.delete
        expect(candidate.save).to be false
      end
    end
  end

  describe '#deleted?' do
    subject(:candidate) { create(:candidate, name_first: 'John') }
    it 'reflects deleted?' do
      expect { candidate.delete }.to change(candidate, :deleted?)
        .from(false)
        .to(true)
    end
  end

  describe '#save!' do
    subject(:candidate) { build(:candidate, name_first: 'John') }
    context 'when updating an new candidate' do
      it 'successfully saves an alteration' do
        candidate.name_first = 'Jane'

        expect(candidate)
          .to receive(:post)
          .with(kind_of(Pathname),
                hash_including(name_first: 'Jane'))
          .and_call_original
        expect(candidate.save!).to be true

        expect(candidate.persisted?).to be true
        expect(candidate.name_first).to eql 'Jane'
      end
    end

    context 'when encountering a deleted item' do
      subject(:candidate) { create(:candidate, name_first: 'John') }
      it 'raises an error when previously deleted' do
        candidate.delete
        expect { candidate.save! }
          .to raise_error(BlockScore::Error, 'candidate is already deleted')
      end
    end
  end

  describe '#attributes' do
    let(:person_id) { create(:person).id }
    subject(:person) { BlockScore::Person.retrieve(person_id) }
    its(:name_first) { is_expected.not_to be_empty }

    it 'retrieves the attributes' do
      f = BlockScore::Candidate.all.first

      expect(BlockScore::Candidate.retrieve(f.id).id).to eql f.id
      expect(BlockScore::Candidate.new(foo: 'bar'))
        .to be_an_instance_of(BlockScore::Candidate)
    end
  end

  describe '#initialize' do
    let(:person_id) { create(:person).id }
    subject(:person) { BlockScore::Person.retrieve(person_id) }
    its(:name_first) { is_expected.not_to be_empty }

    it 'establishes the attributes' do
      f = BlockScore::Candidate.new(id: 'ffff')
      expect(f.id).to eql 'ffff'

      f2 = BlockScore::Candidate.new
      expect(f2.id).to be_nil
    end

    it 'loads the block' do
      f = BlockScore::Candidate.all.first

      expect(BlockScore::Candidate.retrieve(f.id).id).to eql f.id
      foo = BlockScore::Candidate.new(foo: 'bar')
      expect(foo.foo).to eql 'bar'
      expect(foo.method(:foo)).to be_an_instance_of(Method)
      expect { foo.method(:baz) }.to raise_error(NameError)
    end
  end

  describe '#capture_attributes' do
    subject(:candidate) { create(:candidate, name_first: 'John') }
    it 'captures the attributes from a http response' do
      expect(candidate.id).to be_an_instance_of(String)

      expect { candidate.id = '234' }
        .to raise_error(NoMethodError, 'id is immutable')
      expect { candidate.name_first = '234' }.not_to raise_error
      expect { candidate.foo }.to raise_error(NoMethodError)
    end
  end

  describe '#id' do
    subject(:candidate) { create(:candidate, name_last: 'Smith') }

    its(:id) { is_expected.to be_an_instance_of String }
  end

  describe '#wrap_hash' do
    subject(:person) { create(:person, name_last: 'Smith') }
    let(:expectation) do
      OpenStruct.new(address: 'no_match',
                     address_risk: 'low',
                     identification: 'no_match',
                     date_of_birth: 'not_found',
                     ofac: 'no_match',
                     pep: 'no_match')
    end

    its(:details) { is_expected.to eql expectation }
  end

  describe '#inspect' do
    subject(:candidate_inspection) { create(:candidate).inspect }

    it { is_expected.to be_an_instance_of String }
    it { is_expected.to start_with('#<BlockScore::Candidate:0x') }
  end
end
