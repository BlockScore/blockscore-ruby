require File.expand_path(File.join(__FILE__, '../test_helper'))

class RequestTest < Minitest::Test
  def without_authentication
    BlockScore.api_key(nil) # clear API key
  end

  def with_authentication
    BlockScore.api_key('sk_test_a1ed66cc16a7cbc9f262f51869da31b3')
  end

  # Unauthenticated requests should return an AuthenticationError.
  def test_unauthentication_request
    without_authentication

    assert_raises BlockScore::AuthenticationError do
      TestClient.create_person
    end

    # reset API key or all tests run afterwards will fail.
    with_authentication
  end
end
