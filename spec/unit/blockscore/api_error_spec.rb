module BlockScore
  RSpec.describe APIError do
    let(:message) { '(Type: api_error) An error occurred. (Status: 500)' }
    subject { -> { BlockScore::Person.retrieve('500') } }

    it_behaves_like 'an error'
  end
end