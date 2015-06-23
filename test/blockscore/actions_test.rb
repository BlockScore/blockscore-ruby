require File.expand_path(File.join(__FILE__, '../../test_helper'))
require File.expand_path(File.join(__FILE__, '../../support/fake_resource'))

class ActionsTest < Minitest::Test
  context 'actions' do
    setup do
      @mock = BlockScore::FakeResource
      @resource = BlockScore::FakeResource.new(id: 'abc123')
    end

    context 'all' do
      should 'make a GET request to the correct endpoint' do
        @mock.expects(:request).with(:get, 'https://api.blockscore.com/fake_resources', {}).once
        @mock.all
      end

      should 'accept an options hash' do
        @mock.expects(:request).with(:get, 'https://api.blockscore.com/fake_resources', {count: 15, offset: 3}).once
        @mock.all(count: 15, offset: 3)
      end
    end

    context 'create' do
      should 'make a POST request to the correct endpoint' do
        @mock.expects(:request).with(:post, 'https://api.blockscore.com/fake_resources', {}).once
        @mock.create
      end

      should 'accept a params hash' do
        @mock.expects(:request).with(:post, 'https://api.blockscore.com/fake_resources', {name: 'Gerald', nickname: 'G-Eazy'}).once
        @mock.create(name: 'Gerald', nickname: 'G-Eazy')
      end
    end

    context 'delete' do
      should 'make a DELETE request to the correct endpoint' do
        @resource.class.expects(:delete).with('https://api.blockscore.com/fake_resources/abc123', {}).once
        @resource.expects(:deleted).returns(true).once
        @resource.delete
        assert @resource.deleted
      end
    end

    context 'retrieve' do
      should 'make a GET request to the correct endpoint' do
        @mock.expects(:request).with(:get, 'https://api.blockscore.com/fake_resources/abc123', {}).once
        @mock.retrieve('abc123')
      end
    end

    context 'update' do
      should 'make a PATCH request to the correct endpoint' do
        @resource.class.expects(:request).with(:patch, 'https://api.blockscore.com/fake_resources/abc123', {name: 'Gerald'}).once
        @resource.name = 'Gerald'
        @resource.save
        @resource.expects(:name).returns('Gerald').once
        assert_equal 'Gerald', @resource.name
      end
    end
  end
end
