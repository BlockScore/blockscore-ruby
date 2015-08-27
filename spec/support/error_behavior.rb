require 'blockscore/util'

RSpec.shared_context 'an error' do
  it do
    should raise_error(described_class) do |raised|
      expect(raised.message).to eq(message)
    end
  end
end
