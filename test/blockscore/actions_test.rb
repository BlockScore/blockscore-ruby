require File.expand_path(File.join(__FILE__, '../../test_helper'))
require File.expand_path(File.join(__FILE__, '../../support/fake_resource'))

class ActionsTest < Minitest::Test
  context 'all' do
    setup do
      @index_stub = stub_request(:get, %r(.*api.blockscore.com/fake_resources)).
                      to_return({body: {}.to_json})
    end

    should 'make a GET request to the correct endpoint' do
      BlockScore::FakeResource.all
      assert_requested(@index_stub, times: 1)
    end

    should 'accept an options hash' do
      BlockScore::FakeResource.all(count: 15, offset: 3)
      assert_requested(@index_stub, times: 1)
    end
  end

  context 'create' do
    setup do
      @create_stub = stub_request(:post, %r(.*api.blockscore.com/fake_resources)).
                      to_return({body: {}.to_json})
    end

    should 'make a POST request to the correct endpoint' do
      BlockScore::FakeResource.create
      assert_requested(@create_stub, times: 1)
    end

    should 'accept a params hash' do
      BlockScore::FakeResource.create(name: 'Gerald', nickname: 'G-Eazy')
      assert_requested(@create_stub, times: 1)
    end
  end

  context 'delete' do
    setup do
      @delete_stub = stub_request(:delete, %r(.*api.blockscore.com/fake_resources/abc123)).
                      to_return({body: {}.to_json})
      @resource = BlockScore::FakeResource.new(id: 'abc123')
    end

    should 'make a DELETE request to the correct endpoint' do
      @resource.delete
      assert @resource.deleted
      assert_requested(@delete_stub, times: 1)
    end
  end

  context 'retrieve' do
    setup do
      @show_stub = stub_request(:get, %r(.*api.blockscore.com/fake_resources/abc123)).
                      to_return({body: {}.to_json})
    end

    should 'make a GET request to the correct endpoint' do
      BlockScore::FakeResource.retrieve('abc123')
      assert_requested(@show_stub, times: 1)
    end
  end

  context 'update' do
    setup do
      @update_stub = stub_request(:patch, %r(.*api.blockscore.com/fake_resources/abc123)).
                      to_return({body: {}.to_json})
      @resource = BlockScore::FakeResource.new(id: 'abc123')
    end

    should 'make a PATCH request to the correct endpoint' do
      @resource.name = 'Gerald'
      @resource.save
      assert_equal 'Gerald', @resource.name
      assert_requested(@update_stub, times: 1)
    end
  end
end
