require File.expand_path(File.join(__FILE__, '../test_helper'))

class CandidateResourceTest < Minitest::Test
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
    candidate.delete
    assert_equal candidate.deleted, true
  end
end
