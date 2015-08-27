module BlockScore
  RSpec.describe NoAPIKeyError do
    subject(:save) { -> { create(:person_params).save } }
    let(:message) { 'No API key was provided.' }
    before { without_authentication }

    it_behaves_like 'an error'
  end
end