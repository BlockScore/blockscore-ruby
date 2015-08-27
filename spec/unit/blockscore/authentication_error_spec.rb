module BlockScore
  RSpec.describe AuthenticationError do
    it do
      expect { BlockScore::Person.retrieve('401') }.to raise_error(described_class) do |raised|
        expect(raised.error_type).to eq('authentication_error')
        expect(raised.http_status).to eq(401)
        msg = '(Type: authentication_error) The provided API key is invalid. (Status: 401)'
        expect(raised.message).to eq(msg)
      end
    end
  end
end