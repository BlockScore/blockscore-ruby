require 'test_helper'
require 'test/unit/active_support'

class CandidateResourceTest < ActiveSupport::TestCase
  include ResourceTest

  def test_history
    candidate = TestClient.create_candidate
    response = candidate.send(:history)
    assert_equal Array, response.class
  end

  def test_hits
    candidate = TestClient.create_candidate
    response = candidate.send(:hits)
    assert_equal Array, response.class
  end

  def test_delete
    candidate = TestClient.create_candidate
    response = candidate.send(:delete)
    assert_equal BlockScore::Candidate, response.class
  end
end
