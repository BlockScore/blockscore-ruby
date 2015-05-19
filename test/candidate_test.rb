require 'test_helper'
require 'test/unit/active_support'

class CandidateResourceTest < ActiveSupport::TestCase
  include ResourceTest

  def test_history
    candidate = TestClient.create_candidate
    response = candidate.history
    assert_equal Array, response.class
  end

  def test_hits
    candidate = TestClient.create_candidate
    response = candidate.hits
    assert_equal Array, response.class
  end

  def test_update
    candidate = TestClient.create_candidate
    candidate.name_first = 'Chris'
    assert_equal true, candidate.save
    assert_equal candidate.name_first, 'Chris'
  end
  
  def test_delete
    candidate = TestClient.create_candidate
    response = candidate.delete
    assert_equal BlockScore::Candidate, response.class
  end
end
