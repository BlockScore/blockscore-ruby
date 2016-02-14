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

  describe '.retrieve' do
    let(:candidate_id) { create(:candidate).id }
    subject(:candidate) { described_class.retrieve(candidate_id) }

    it { is_expected.to be_persisted }
    its(:name_first) { is_expected.not_to be_empty }
    it { is_expected.to be_an_instance_of described_class }
  end

  # NB: At the time of writing, the testing API does not reset. Making this
  #     test less then perfect. To work around the near certain availability
  #     of historical candidates from other tests known candidates are created
  #     and checked. This has the side effect of being susceptible to race
  #     conditions if tested against the live API in parallel.
  describe '.all' do
    let(:uniq_token_one) { '05816347d2234ef4a92465e9784c7ce1' }
    let(:uniq_token_two) { 'b4cd5fb645788c3b37c11407b83d7741' }
    let!(:c1) { create(:candidate, name_first: 'John', name_last: uniq_token_one) }
    let!(:c2) { create(:candidate, name_first: 'John', name_last: uniq_token_two) }
    subject(:candidates) { described_class.all }

    it { is_expected.not_to be_empty }
    it { expect(candidates[0].name_last).to eql uniq_token_two }
    it { expect(candidates[1].name_last).to eql uniq_token_one }
  end

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

  describe '#delete' do
    subject(:candidate) { create(:candidate) }
    let(:candidate_id) { candidate.id }
    before { candidate.delete }

    it { is_expected.not_to be_persisted }
    it { expect(candidate.deleted).to be true }
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
