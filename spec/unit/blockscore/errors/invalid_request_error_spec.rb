module BlockScore
  RSpec.describe InvalidRequestError do
    subject { -> { BlockScore::Person.create(first_name: 'John') } }
    let(:message) do
      '(Type: invalid_request_error) One or more required parameters are invalid (name_first) (Status: 400)'
    end

    it_behaves_like 'an error'
  end
end
