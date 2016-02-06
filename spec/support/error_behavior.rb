RSpec.shared_context 'an error' do
  it do
    expect { subject.call }.to raise_error do |raised|
      expect(raised).to be_a(described_class)
      expect(raised.message).to eql(message)
    end
  end
end
