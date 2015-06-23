require File.expand_path(File.join(__FILE__, '../../test_helper'))

class CandidateResourceTest < Minitest::Test
  include ResourceTest

  def member_test(member, response_type)
    candidate = create_candidate
    response = candidate.send(member)

    assert_requested(@api_stub, times: 2)
    assert_equal response_type, response.class
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
    assert_requested(@api_stub, times: 2)
    assert_equal candidate.name_first, 'Chris'
  end

  def test_delete
    candidate = create_candidate
    candidate.delete

    assert_requested(@api_stub, times: 2) # 1 for create, 1 for delete
    assert_equal candidate.deleted, true
  end

  def test_search
    candidate = create_candidate
    hits = candidate.search
    
    assert hits.kind_of?(Array)
    hits.each { |hit| assert hit.kind_of?(BlockScore::WatchlistHit) }
  end
end
