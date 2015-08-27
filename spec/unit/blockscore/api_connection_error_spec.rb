module BlockScore
  RSpec.describe APIConnectionError do
    it 'connection_refused' do
      stub_request(:get, /.*api\.blockscore\.com\/people\/connection_refused/).to_raise(Errno::ECONNREFUSED)
      expect { BlockScore::Person.retrieve('connection_refused') }.to raise_error(described_class) do |raised|
        expect(raised.message).to eq('Connection refused - Exception from WebMock')
      end
    end
  end
end