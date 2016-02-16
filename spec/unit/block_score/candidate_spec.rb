require 'faker'

RSpec.describe BlockScore::Candidate do
  describe '.new' do
    subject(:candidate) { described_class.new(attributes_for(:candidate)) }

    its(:persisted?) { is_expected.to be false }
    it { is_expected.to be_an_instance_of described_class }
  end

  describe '.create' do
    subject(:candidate) { described_class.create }

    its(:persisted?) { is_expected.to be true }
    it { is_expected.to be_an_instance_of described_class }
  end

  describe '#save' do
    context 'when iteratively updating an existing candidate' do
      subject(:candidate) { create(:candidate, name_first: 'John') }
      before do
        candidate.name_first = 'Jane'
        candidate.save

        candidate.name_middle = 'Arel'
        candidate.save
      end

      its(:persisted?) { is_expected.to be true }
      its(:name_first) { is_expected.to eql 'Jane' }
      its(:name_middle) { is_expected.to eql 'Arel' }
    end
  end

  describe '#history' do
    subject(:candidate) { create(:candidate, name_first: 'version_0') }
    before do
      candidate.name_first = 'version_1'
      candidate.save

      candidate.name_first = 'version_2'
      candidate.save
    end

    it { expect(candidate.history[0].class).to be described_class }
    it { expect(candidate.history[0].name_first).to eql 'version_2' }
    it { expect(candidate.history[1].name_first).to eql 'version_1' }
    it { expect(candidate.history[2].name_first).to eql 'version_0' }
  end

  describe '#hits' do
    subject(:candidate) { create(:watched_person_candidate) }
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
        .to all(be_an_instance_of(BlockScore::WatchlistHit))
    end
  end

  describe '#search' do
    subject(:candidate_search) { create(:watched_person_candidate).search }

    it { is_expected.not_to be_empty }
    it { is_expected.to all(be_an_instance_of(BlockScore::WatchlistHit)) }
    it 'has a good confidence' do
      expect(candidate_search.first.confidence).to be(1.0)
    end

    context 'cannot search on unsaved candidate' do
      subject(:candidate) { build(:watched_person_candidate) }

      it 'is an invalid request' do
        expect { candidate.search }
          .to raise_error(BlockScore::NotFoundError,
                          '(Type: invalid_request_error) ' \
                          'Candidate with id  could not be found (Status: 404)')
      end
    end

    context 'search by company' do
      subject(:candidate_search) do
        create(:watched_person_candidate).search(match_type: 'company')
      end

      it { is_expected.to be_empty }
    end

    context 'search with similarity' do
      subject(:candidate_search) do
        create(:watched_person_candidate).search(similarity_threshold: 1.0)
      end

      it { is_expected.not_to be_empty }
      it { is_expected.to all(be_an_instance_of(BlockScore::WatchlistHit)) }
      it 'has a good confidence' do
        expect(candidate_search.first.confidence).to be(1.0)
      end
    end

    context 'search empty candidate with similarity' do
      subject(:candidate_search) do
        described_class.create.search(similarity_threshold: 0.0)
      end

      it { is_expected.to be_empty }
    end

    context 'proof of similarity filtering' do
      subject(:candidate_search) do
        described_class
          .create(name_first: 'mohammed')
          .search(similarity_threshold: 0.98)
      end

      it { is_expected.to be_empty }
    end

    context 'proof of similarity filtering (rejected and accepted)' do
      subject(:candidate_search) do
        described_class
          .create(name_first: 'mohammed')
          .search(similarity_threshold: 0.93)
      end

      it { expect(candidate_search.size).to be > 6 }
    end

    context 'proof of similarity filtering with match on company' do
      subject(:candidate_search) do
        described_class
          .create(name_first: 'mohammed')
          .search(match_type: 'company', similarity_threshold: 0.93)
      end

      it { expect(candidate_search.size).to be(0) }
    end
  end
end
