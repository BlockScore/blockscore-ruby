require 'test_helper'
require 'test/unit/active_support'

class CandidateResourceTest < ActiveSupport::TestCase
  include ResourceTest

  def member_test(member)
    id = TestClient.create_candidate["id"]
    response = TestClient.client.candidates.send(member, id)
    assert_equal 200, response.code
  end

  def test_history
    member_test(:history)
  end

  def test_hits
    member_test(:hits)
  end

  def test_delete
    member_test(:delete)
  end
end
