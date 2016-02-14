RSpec.describe BlockScore::APIConnectionError do
  let(:stubbed_route_pattern) { %r{.*api\.blockscore\.com/people/abc123} }
  let(:stubbed_error) { Errno::ECONNREFUSED }
  let(:message) { 'Connection refused - Exception from WebMock' }
  subject { BlockScore::Person.retrieve('abc123') }

  before { stub_request(:get, stubbed_route_pattern).to_raise(stubbed_error) }

  it_behaves_like 'an error'
end
