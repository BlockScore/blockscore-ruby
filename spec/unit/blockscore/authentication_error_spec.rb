module BlockScore
  RSpec.describe AuthenticationError do
    let(:message) { '(Type: authentication_error) The provided API key is invalid. (Status: 401)' }
    subject(:retrieve) { -> { BlockScore::Person.retrieve('401') } }

    it_behaves_like 'an error'
  end
end
