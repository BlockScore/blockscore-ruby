require 'blockscore/util'

RSpec.shared_context 'a resource' do
  let(:resource) do
    BlockScore::Util.to_underscore(described_class.to_s[/BlockScore::(\w+)/, 1])
  end

  it '#create' do
    create(:"#{resource}_params")
    assert_requested(@api_stub, times: 1)
  end

  it '#retrieve' do
    r = build(resource)

    expect(resource).to eq(described_class.retrieve(r.id).object)
    assert_requested(@api_stub, times: 1)
  end

  describe '#all' do
    it do
      described_class.all

      assert_requested(@api_stub, times: 1)
    end

    it 'with count' do
      response = described_class.all(count: 2)

      expect(2).to eq(response.count)
      assert_requested(@api_stub, times: 1)
    end

    it 'with count and offset' do
      response = described_class.all(count: 2, offset: 2)

      expect(2).to eq(response.count)
      assert_requested(@api_stub, times: 1)
    end
  end

  it 'init_and_save' do
    params = build(resource).attributes
    obj = described_class.new

    params.each do |key, value|
      obj.public_send "#{key.to_s}=".to_sym, value
    end

    expect(obj.save).to be(true)
    assert_requested(@api_stub, times: 1)
  end
end
