module BlockScore
  RSpec.describe APIConnectionError do
    let(:stubbed_route_pattern) { %r(.*api\.blockscore\.com/people/connection_refused) }
    let(:stubbed_error) { Errno::ECONNREFUSED }
    let(:message) { 'Connection refused - Exception from WebMock' }
    subject { -> { BlockScore::Person.retrieve('connection_refused') } }

    before { stub_request(:get, stubbed_route_pattern).to_raise(stubbed_error) }

    it_behaves_like 'an error'
  end
end