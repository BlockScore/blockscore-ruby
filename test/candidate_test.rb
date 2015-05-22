require File.expand_path(File.join(__FILE__, '../test_helper'))

class CandidateResourceTest < Minitest::Test
  include ResourceTest

  def member_test(member, response_type)
    candidate = TestClient.create_candidate
    response = candidate.send(member)
    assert_equal response_type, response.class
  end

  def create_candidate
    TestClient.create_candidate
  end

  def test_history
    member_test(:history, Array)
  end

  def test_hits
    member_test(:hits, Array)
  end

  def test_update
    candidate = create_candidate
    candidate.name_first = 'Chris'
    assert_equal true, candidate.save
    assert_equal candidate.name_first, 'Chris'
  end

  def test_delete
    candidate = create_candidate
    candidate.delete
    assert_equal candidate.deleted, true
  end
end
