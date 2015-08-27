module BlockScore
  RSpec.describe APIError do
    it do
      with_authentication
      expect { BlockScore::Person.retrieve('500') }.to raise_error(described_class) do |raised|
        expect(raised.error_type).to eq('api_error')
        expect(raised.http_status).to eq(500)
        msg = '(Type: api_error) An error occurred. (Status: 500)'
        expect(raised.message).to eq(msg)
      end
    end
  end
end