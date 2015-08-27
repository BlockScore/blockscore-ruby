module BlockScore
  RSpec.describe Base do
    let(:mock) { BlockScore::FakeResource }
    let(:resource) { BlockScore::FakeResource.new(id: 'abc123') }

    describe '#all' do
      it 'uses the correct endpoint' do
        expect(mock).to receive(:request).with(:get, 'https://api.blockscore.com/fake_resources', {}).once
        mock.all
      end

      it 'accepts options' do
        expect(mock).to receive(:request).with(:get, 'https://api.blockscore.com/fake_resources', count: 15, offset: 3).once
        mock.all(count: 15, offset: 3)
      end
    end

    describe '#create' do
      it 'uses the correct endpoint' do
        expect(mock).to receive(:request).with(:post, 'https://api.blockscore.com/fake_resources', {}).once
        mock.create
      end

      it 'accepts options' do
        expect(mock).to receive(:request).with(:post, 'https://api.blockscore.com/fake_resources', name: 'Gerald', nickname: 'G-Eazy').once
        mock.create(name: 'Gerald', nickname: 'G-Eazy')
      end
    end

    describe '#delete' do
      it 'uses the correct endpoint' do
        expect(resource.class).to receive(:delete).with('https://api.blockscore.com/fake_resources/abc123', {}).once
        resource.delete
        expect(resource.deleted).to be_truthy
      end
    end

    describe '#retrieve' do
      it 'uses the correct endpoint' do
        expect(mock).to receive(:request).with(:get, 'https://api.blockscore.com/fake_resources/abc123', {}).once
        mock.retrieve('abc123')
      end
    end

    describe '#update' do
      it 'uses the correct endpoint' do
        expect(resource.class).to receive(:request).with(:patch, 'https://api.blockscore.com/fake_resources/abc123', name: 'Gerald').once
        resource.name = 'Gerald'
        resource.save
        expect(resource).to receive(:name).and_return('Gerald').once
        expect(resource.name).to eq('Gerald')
      end
    end
  end
end
