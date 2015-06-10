require File.expand_path(File.join(__FILE__, '../test_helper'))

class RequestTest < Minitest::Test
  # Unauthenticated requests should return an AuthenticationError.
  def test_unauthentication_request
    without_authentication

    assert_raises BlockScore::NoAPIKeyError do
      create_person
    end

    # reset API key or all tests run afterwards will fail.
    with_authentication
  end

  def test_not_found_error
    with_authentication

    assert_raises BlockScore::NotFoundError do
      BlockScore::Person.retrieve('404')
    end
  end

  def test_invalid_request_error
    assert_raises BlockScore::InvalidRequestError do
      BlockScore::Person.retrieve('400')
    end
  end

  def test_api_error
    with_authentication

    assert_raises BlockScore::APIError do
      BlockScore::Person.retrieve('500')
    end
  end

  def test_authentication_error
    assert_raises BlockScore::AuthenticationError do
      BlockScore::Person.retrieve('401')
    end
  end

  def test_socket_error
    stub_request(:get, /.*api\.blockscore\.com\/people\/socket_error/).
      to_raise(SocketError)

    assert_raises(BlockScore::APIConnectionError) do
      BlockScore::Person.retrieve('socket_error')
    end
  end

  def test_connection_refused
    stub_request(:get, /.*api\.blockscore\.com\/people\/connection_refused/).
      to_raise(Errno::ECONNREFUSED)

    assert_raises(BlockScore::APIConnectionError) do
      BlockScore::Person.retrieve('connection_refused')
    end
  end
end
