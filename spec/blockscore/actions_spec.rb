require File.expand_path(File.join('spec/blockscore/actions_test.rb', '../../spec_helper'))
require File.expand_path(File.join('spec/blockscore/actions_test.rb', '../../support/fake_resource'))
require File.expand_path(File.join('spec/blockscore/actions_test.rb', '../../support/resource_behavior'))

module BlockScore
  RSpec.describe Base do
    before do
      @mock = BlockScore::FakeResource
      @resource = BlockScore::FakeResource.new(id: 'abc123')
    end

    it 'test_all_endpoint' do
      expect(@mock).to receive(:request).with(:get, 'https://api.blockscore.com/fake_resources', {}).once
      @mock.all
    end

    it 'test_all_options' do
      expect(@mock).to receive(:request).with(:get, 'https://api.blockscore.com/fake_resources', count: 15, offset: 3).once
      @mock.all(count: 15, offset: 3)
    end

    it 'test_create_endpoint' do
      expect(@mock).to receive(:request).with(:post, 'https://api.blockscore.com/fake_resources', {}).once
      @mock.create
    end

    it 'test_create_params' do
      expect(@mock).to receive(:request).with(:post, 'https://api.blockscore.com/fake_resources', name: 'Gerald', nickname: 'G-Eazy').once
      @mock.create(name: 'Gerald', nickname: 'G-Eazy')
    end

    it 'test_delete_endpoint' do
      expect(@resource.class).to receive(:delete).with('https://api.blockscore.com/fake_resources/abc123', {}).once
      @resource.delete
      expect(@resource.deleted).to be_truthy
    end

    it 'test_retrieve_endpoint' do
      expect(@mock).to receive(:request).with(:get, 'https://api.blockscore.com/fake_resources/abc123', {}).once
      @mock.retrieve('abc123')
    end

    it 'test_update_endpoint' do
      expect(@resource.class).to receive(:request).with(:patch, 'https://api.blockscore.com/fake_resources/abc123', name: 'Gerald').once
      @resource.name = 'Gerald'
      @resource.save
      expect(@resource).to receive(:name).and_return('Gerald').once
      expect(@resource.name).to eq('Gerald')
    end
  end
end
