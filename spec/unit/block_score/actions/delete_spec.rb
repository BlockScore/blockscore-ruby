require 'faker'

RSpec.describe BlockScore::Actions::Delete, vcr: true do
  describe '#delete' do
    subject(:candidate) { create(:candidate) }
    before do
      expect(candidate.delete).to be true
    end

    its(:persisted?) { is_expected.to be false }
    its(:deleted?) { is_expected.to be true }

    context 'previously deleted' do
      it 'was already deleted' do
        expect(candidate.delete).to be false
      end
    end
  end

  describe '#delete!' do
    subject(:candidate) { create(:candidate) }
    before do
      expect(BlockScore::Candidate)
        .to receive(:delete)
        .with(kind_of(Pathname), {})
        .and_call_original

      expect(candidate.delete!).to be true
    end

    its(:persisted?) { is_expected.to be false }
    its(:deleted?) { is_expected.to be true }

    context 'previously deleted' do
      it 'was already deleted' do
        expect { candidate.delete! }
          .to raise_error(BlockScore::Error,
                          'candidate is already deleted')
      end
    end
  end

  describe '#delete!' do
    subject(:candidate) { create(:candidate) }
    before do
      expect(BlockScore::Candidate)
        .to receive(:delete)
        .with(kind_of(Pathname), {})
        .and_call_original

      candidate.delete
    end
    it { is_expected.not_to be_persisted }
  end
end
