RSpec.shared_context 'an error' do
  it do
    expect { subject }.to raise_error do |raised|
      expect(raised).to be_an_instance_of(described_class)
      expect(raised.message).to eql(message)
    end
  end
end
