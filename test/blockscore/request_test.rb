require File.expand_path(File.join(__FILE__, '../../test_helper'))

class RequestTest < Minitest::Test
  # Unauthenticated requests should return an AuthenticationError.
  should 'using a nil API key should raise an exception' do
    without_authentication

    raised = assert_raises BlockScore::NoAPIKeyError do
      create_person
    end

    assert_equal 'No API key was provided.', raised.message

    # reset API key or all tests run afterwards will fail.
    with_authentication
  end

  should 'requesting a resource that does not exist should raise a NotFoundError' do
    with_authentication

    raised = assert_raises BlockScore::NotFoundError do
      BlockScore::Person.retrieve('404')
    end

    assert_equal 'not_found_error', raised.error_type
    assert_equal 404, raised.http_status

    msg = '(Type: not_found_error) Person with ID ab973197319713ba could not be found (Status: 404)'
    assert_equal msg, raised.message
  end

  should 'making a request without a required param should raise an InvalidRequestError' do
    raised = assert_raises BlockScore::InvalidRequestError do
      BlockScore::Person.retrieve('400')
    end

    assert_equal 'invalid_request_error', raised.error_type
    assert_equal 400, raised.http_status

    msg = '(Type: invalid_request_error) One of more parameters is invalid. (name_first) (Status: 400)'
    assert_equal msg, raised.message
  end

  should 'a server error should raise an APIError' do
    with_authentication

    raised = assert_raises BlockScore::APIError do
      BlockScore::Person.retrieve('500')
    end

    assert_equal 'api_error', raised.error_type
    assert_equal 500, raised.http_status

    msg = '(Type: api_error) An error occurred. (Status: 500)'
    assert_equal msg, raised.message
  end

  should 'making a request with an invalid API key should raise an AuthenticationError' do
    raised = assert_raises BlockScore::AuthenticationError do
      BlockScore::Person.retrieve('401')
    end

    assert_equal 'authentication_error', raised.error_type
    assert_equal 401, raised.http_status

    msg = '(Type: authentication_error) The provided API key is invalid. (Status: 401)'
    assert_equal msg, raised.message
  end

  should 'a socket error should raise an APIConnectionError' do
    stub_request(:get, /.*api\.blockscore\.com\/people\/socket_error/).
      to_raise(SocketError)

    raised = assert_raises(BlockScore::APIConnectionError) do
      BlockScore::Person.retrieve('socket_error')
    end

    assert_equal 'Exception from WebMock', raised.message
  end

  should 'connection_refused should raise an APIConnectionError' do
    stub_request(:get, /.*api\.blockscore\.com\/people\/connection_refused/).
      to_raise(Errno::ECONNREFUSED)

    raised = assert_raises(BlockScore::APIConnectionError) do
      BlockScore::Person.retrieve('connection_refused')
    end

    assert_equal 'Connection refused - Exception from WebMock', raised.message
  end

  should 'creating a new instance of an API resource should not fetch over the network' do
    BlockScore::Person.new
    assert_not_requested(@api_stub)
  end

  should 'creating a new resource from a hash should not cause a network request' do
    BlockScore::Person.new(create(:person))
    assert_not_requested(@api_stub)
  end

  should 'setting an attribute should not cause a network request' do
    candidate = BlockScore::Candidate.new
    candidate.name_first = 'John'
    assert_not_requested(@api_stub)
  end
end
