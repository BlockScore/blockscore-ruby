module BlockScore
  RSpec.describe Base do
    let(:resource) { BlockScore::FakeResource.new(id: 'abc123') }
    let(:route) { 'https://api.blockscore.com/fake_resources' }
    subject(:mock) { BlockScore::FakeResource }

    describe '#all' do
      it 'uses the correct endpoint' do
        should receive(:request).with(:get, route, {}).once
        mock.all
      end

      it 'accepts options' do
        should receive(:request).with(:get, route, count: 15, offset: 3).once
        mock.all(count: 15, offset: 3)
      end
    end

    describe '#create' do
      it 'uses the correct endpoint' do
        should receive(:request).with(:post, route, {}).once
        mock.create
      end

      it 'accepts options' do
        should receive(:request).with(:post, route, name: 'Gerald', nickname: 'G-Eazy').once
        mock.create(name: 'Gerald', nickname: 'G-Eazy')
      end
    end

    describe '#delete' do
      let(:route) { 'https://api.blockscore.com/fake_resources/abc123' }

      it 'uses the correct endpoint' do
        should receive(:delete).with(route, {}).once
        resource.delete
        expect(resource.deleted).to be_truthy
      end
    end

    describe '#retrieve' do
      let(:route) { 'https://api.blockscore.com/fake_resources/abc123' }

      it 'uses the correct endpoint' do
        should receive(:request).with(:get, route, {}).once
        mock.retrieve('abc123')
      end
    end

    describe '#update' do
      let(:route) { 'https://api.blockscore.com/fake_resources/abc123' }

      it 'uses the correct endpoint' do
        should receive(:request).with(:patch, route, name: 'Gerald').once
        resource.name = 'Gerald'
        resource.save
        expect(resource).to receive(:name).and_return('Gerald').once
        expect(resource.name).to eq('Gerald')
      end
    end
  end
end
