require 'faker'

RSpec.describe BlockScore::Base do
  describe '#save' do
    context 'when creating a new candidate' do
      subject(:candidate) { build(:candidate) }
      before { candidate.save }

      it { is_expected.to be_persisted }
      its(:name_first) { is_expected.not_to be_empty }
    end

    context 'when updating an existing candidate' do
      subject(:candidate) { create(:candidate, name_first: 'John') }
      before do
        candidate.name_first = 'Jane'
        candidate.save
      end

      it { is_expected.to be_persisted }
      its(:name_first) { is_expected.to eql 'Jane' }
    end
  end

  describe '#refresh' do
    subject(:candidate) { create(:candidate, name_last: 'Smith') }
    before do
      candidate.name_last = 'John'
      candidate.refresh
    end

    its(:name_last) { is_expected.to eql 'Smith' }
  end

  describe '#inspect' do
    subject(:candidate_inspection) { create(:candidate).inspect }

    it { is_expected.to be_an_instance_of String }
    it { is_expected.to match(/\A#<BlockScore::Candidate:0x/) }
  end
end
