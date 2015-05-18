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
    success = candidate.update(:ssn => '1234')
    assert_equal true, success
    assert_equal candidate.ssn , '1234'
  end
  
  def test_delete
    candidate = TestClient.create_candidate
    response = candidate.delete
    assert_equal BlockScore::Candidate, response.class
  end
end
