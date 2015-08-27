module BlockScore
  RSpec.describe InvalidRequestError do
    let(:message) { '(Type: invalid_request_error) One of more parameters is invalid. (name_first) (Status: 400)' }
    subject(:retrieve) { -> { BlockScore::Person.retrieve('400') } }

    it_behaves_like 'an error'
  end
end