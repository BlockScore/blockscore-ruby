module BlockScore
  RSpec.describe InvalidRequestError do
    it do
      expect { BlockScore::Person.retrieve('400') }.to raise_error(described_class) do |raised|
        expect(raised.error_type).to eq('invalid_request_error')
        expect(raised.http_status).to eq(400)
        msg = '(Type: invalid_request_error) One of more parameters is invalid. (name_first) (Status: 400)'
        expect(raised.message).to eq(msg)
      end
    end
  end
end