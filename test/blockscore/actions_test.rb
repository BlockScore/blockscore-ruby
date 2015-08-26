require File.expand_path(File.join(__FILE__, '../../test_helper'))
require File.expand_path(File.join(__FILE__, '../../support/fake_resource'))

class ActionsTest < Minitest::Test
  def setup
    super()
    @mock = BlockScore::FakeResource
    @resource = BlockScore::FakeResource.new(id: 'abc123')
  end

  def test_all_endpoint
    @mock.expects(:request).with(:get, 'https://api.blockscore.com/fake_resources', {}).once
    @mock.all
  end

  def test_all_options
    @mock.expects(:request).with(:get, 'https://api.blockscore.com/fake_resources', {count: 15, offset: 3}).once
    @mock.all(count: 15, offset: 3)
  end

  def test_create_endpoint
    @mock.expects(:request).with(:post, 'https://api.blockscore.com/fake_resources', {}).once
    @mock.create
  end

  def test_create_params
    @mock.expects(:request).with(:post, 'https://api.blockscore.com/fake_resources', {name: 'Gerald', nickname: 'G-Eazy'}).once
    @mock.create(name: 'Gerald', nickname: 'G-Eazy')
  end

  def test_delete_endpoint
    @resource.class.expects(:delete).with('https://api.blockscore.com/fake_resources/abc123', {}).once
    @resource.expects(:deleted).returns(true).once
    @resource.delete
    assert @resource.deleted
  end

  def test_retrieve_endpoint
    @mock.expects(:request).with(:get, 'https://api.blockscore.com/fake_resources/abc123', {}).once
    @mock.retrieve('abc123')
  end

  def test_update_endpoint
    @resource.class.expects(:request).with(:patch, 'https://api.blockscore.com/fake_resources/abc123', {name: 'Gerald'}).once
    @resource.name = 'Gerald'
    @resource.save
    @resource.expects(:name).returns('Gerald').once
    assert_equal 'Gerald', @resource.name
  end
end
