module BlockScore
  RSpec.describe Connection do
    class ConnectionObject
      include BlockScore::Connection

      def resource # an unspoken contract.
        nil
      end
    end

    let(:connector) { ConnectionObject.new }

    let(:api_key) { BlockScore.api_key }

    before do
      ua = "blockscore-ruby/#{BlockScore::VERSION} (https://github.com/BlockScore/blockscore-ruby)"
      expect(HTTParty).to receive(:send).with(
        :get,
        '/foo?',
        basic_auth: {
          username: api_key,
          password: ''
        },
        headers: {
          'Accept' => 'application/vnd.blockscore+json;version=4',
          'User-Agent' => ua,
          'Content-Type' => 'application/json'
        },
        body: nil
      )

      expect(BlockScore::Response).to receive(:handle_response)
    end

    describe 'overriding API key' do
      let(:api_key) { "bar" }

      it 'uses the param' do
        connector.get('/foo', api_key: api_key)
      end
    end

    describe 'using the global API key' do
      it 'uses the param' do
        connector.get('/foo', {})
      end
    end
  end
end
