require File.expand_path(File.join(__FILE__, '../../test_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../../test/support/resource_test'))

class CandidateResourceTest < Minitest::Test
  include ResourceTest

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
end
