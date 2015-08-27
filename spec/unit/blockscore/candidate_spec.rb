module BlockScore
  RSpec.describe Candidate do
    it_behaves_like 'a resource'

    it 'updates' do
      candidate = create(:candidate_params)
      candidate.name_first = 'Chris'
      expect(candidate.save).to eq(true)
      assert_requested(@api_stub, times: 2)
      expect('Chris').to eq(candidate.name_first)
    end

    it 'deletes' do
      candidate = create(:candidate_params)
      candidate.delete
      assert_requested(@api_stub, times: 2)
      expect(true).to eq(candidate.deleted)
    end
  end
end
