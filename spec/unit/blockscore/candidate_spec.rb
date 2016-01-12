require 'faker'

module BlockScore
  RSpec.describe Candidate do
    describe '.new' do
      subject(:candidate) { BlockScore::Candidate.new(attributes_for(:candidate)) }

      it { is_expected.not_to be_persisted }
      its(:class) { should be BlockScore::Candidate }
    end

    describe '.create' do
      subject(:candidate) { BlockScore::Candidate.create(attributes_for(:candidate)) }

      it { is_expected.to be_persisted }
      its(:class) { should be BlockScore::Candidate }
    end

    pending '.find' do
      context 'valid candidate id' do
        let(:candidate_id)  { create(:candidate).id }
        subject(:candidate) { BlockScore::Candidate.find(candidate_id) }

        it { is_expected.to be_persisted }
        its(:name_first) { is_expected.not_to be be_empty }
      end

      context 'invalid candidate id' do
        let(:candidate_id) { '6c89646eea50fcaa42ca1fe1667a470b' }

        it { expect { BlockScore::Candidate.find(candidate_id) }.to raise_error BlockScore::RecordNotFound }
      end
    end

    describe '.retrieve' do
      let(:candidate_id)  { create(:candidate).id }
      subject(:candidate) { BlockScore::Candidate.retrieve(candidate_id) }

      it { is_expected.to be_persisted }
      its(:name_first) { is_expected.not_to be be_empty }
      its(:class) { should be BlockScore::Candidate }
    end

    # NB: At the time of writing, the testing API does not reset. Making this
    #     test less then perfect. To work around the near certain availability
    #     of historical candidates from other tests known candidates are created
    #     and checked. This has the side effect of being susceptible to race
    #     conditions if tested against the live API in parallel.
    describe '.all' do
      let(:uniq_token_one) { '05816347d2234ef4a92465e9784c7ce1' }
      let(:uniq_token_two) { 'b4cd5fb645788c3b37c11407b83d7741' }
      subject(:candidates) { BlockScore::Candidate.all }

      before do
        create(:candidate, name_first: 'John', name_last: uniq_token_one)
        create(:candidate, name_first: 'John', name_last: uniq_token_two)
      end

      it { is_expected.not_to be_empty }
      it { expect(candidates[0].name_last).to eq uniq_token_two }
      it { expect(candidates[1].name_last).to eq uniq_token_one }
    end

    describe '#save' do
      context 'when creating a new candidate' do
        subject(:candidate) { build(:candidate) }
        before { candidate.save }

        it { is_expected.to be_persisted }
        its(:name_first) { is_expected.not_to be be_empty }
      end

      context 'when updating an existing candidate' do
        subject(:candidate) { create(:candidate, name_first: 'John') }
        before do
          candidate.name_first = 'Jane'
          candidate.save
        end

        it { is_expected.to be_persisted }
        its(:name_first) { is_expected.to eq 'Jane' }
      end

      pending 'after deleting a candidate' do
        subject(:candidate) { create(:candidate) }
        before do
          candidate.delete
        end

        it { expect { candidate.save }.to raise_error }
      end
    end

    describe '#refresh' do
      subject(:candidate) { create(:candidate, name_last: 'Smith') }
      before do
        candidate.name_last = 'John'
        candidate.refresh
      end

      its(:name_last) { is_expected.to eq 'Smith' }
    end

    describe '#inspect' do
      subject(:candidate_inspection) { create(:candidate).inspect }

      its(:class) { should be String }
      it { is_expected.to match(/^#<BlockScore::Candidate:0x/) }
    end

    describe '#update' do
      subject(:candidate) { create(:candidate, name_first: 'John') }
      before do
        candidate.update(name_first: 'Jane')
      end

      it { is_expected.to be_persisted }
      its(:name_first) { is_expected.to eq 'Jane' }
    end

    describe '#delete' do
      subject(:candidate) { create(:candidate) }
      let(:candidate_id)  { candidate.id }
      before { candidate.delete }

      it { is_expected.not_to be_persisted }
      it { expect { BlockScore::Candidate.retrieve(candidate_id).force! }.to raise_error BlockScore::NotFoundError }
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
      it { expect(candidate.history[0].class).to be BlockScore::Candidate }
      it { expect(candidate.history[0].name_first).to eq 'version_2' }
      it { expect(candidate.history[1].name_first).to eq 'version_1' }
      it { expect(candidate.history[2].name_first).to eq 'version_0' }
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
        VCRHelper.spinlock_until { candidate.hits.count != 0 }
        # ==================================================
      end

      its(:hits) { is_expected.not_to be_empty }
      it { expect(candidate.hits.first.class).to be BlockScore::WatchlistHit }
    end

    describe '#search' do
      subject(:candidate_search) { create(:watched_candidate).search }

      it { is_expected.not_to be_empty }
      it { expect(candidate_search.first.class).to be BlockScore::WatchlistHit }
    end
  end
end
