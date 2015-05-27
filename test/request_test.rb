require File.expand_path(File.join(__FILE__, '../test_helper'))

class RequestTest < Minitest::Test
  # Unauthenticated requests should return an AuthenticationError.
  def test_unauthentication_request
    without_authentication

    assert_raises BlockScore::AuthenticationError do
      create_person
    end

    # reset API key or all tests run afterwards will fail.
    with_authentication
  end

  def test_not_found_error
    with_authentication

    assert_raises BlockScore::InvalidRequestError do
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
end
