require 'faker'

RSpec.describe BlockScore::Candidate do
  describe '.new' do
    subject(:candidate) { described_class.new(attributes_for(:candidate)) }

    it { is_expected.not_to be_persisted }
    it { is_expected.to be_an_instance_of described_class }
  end

  describe '.create' do
    subject(:candidate) { described_class.create(attributes_for(:candidate)) }

    it { is_expected.to be_persisted }
    it { is_expected.to be_an_instance_of described_class }
  end

  describe '#history' do
    subject(:candidate) { create(:candidate, name_first: 'version_0') }
    before do
      candidate.name_first = 'version_1'
      candidate.save

      candidate.name_first = 'version_2'
      candidate.save
    end

    its(:history) { is_expected.not_to be_empty }
    it { expect(candidate.history[0].class).to be described_class }
    it { expect(candidate.history[0].name_first).to eql 'version_2' }
    it { expect(candidate.history[1].name_first).to eql 'version_1' }
    it { expect(candidate.history[2].name_first).to eql 'version_0' }
  end

  describe '#hits' do
    subject(:candidate) { create(:watched_candidate) }
    before do
      candidate.search

      # ==================================================
      # Micro Patch: Spinlock until delay job has processed.
      #
      # After a new recording, the empty responses should be edited out to
      #   prevent baking in the sleeps, as they will be replayed in order.
      VCRHelper.spinlock_until { candidate.hits.any? }
      # ==================================================
    end

    its(:hits) { is_expected.not_to be_empty }
    it 'returns a watchlist hit' do
      expect(candidate.hits)
        .to all(be_an_instance_of BlockScore::WatchlistHit)
    end
  end

  describe '#search' do
    subject(:candidate_search) { create(:watched_candidate).search }

    it { is_expected.not_to be_empty }
    it { is_expected.to all(be_an_instance_of BlockScore::WatchlistHit) }
  end
end
