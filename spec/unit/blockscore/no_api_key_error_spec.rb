module BlockScore
  RSpec.describe NoAPIKeyError do
    subject(:save) { -> { create(:person_params).save } }
    let(:message) { 'No API key was provided.' }
    before { expect(BlockScore).to receive(:api_key).and_return(nil) }

    it_behaves_like 'an error'
  end
end
