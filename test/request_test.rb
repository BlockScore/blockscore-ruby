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
end
