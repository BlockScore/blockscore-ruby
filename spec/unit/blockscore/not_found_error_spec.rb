module BlockScore
  RSpec.describe NotFoundError do
    it do
      with_authentication
      expect { BlockScore::Person.retrieve('404') }.to raise_error(described_class) do |raised|
        expect(raised.error_type).to eq('not_found_error')
        expect(raised.http_status).to eq(404)
        msg = '(Type: not_found_error) Person with ID ab973197319713ba could not be found (Status: 404)'
        expect(raised.message).to eq(msg)
      end
    end
  end
end