require File.expand_path(File.join(__FILE__, '../../test_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), '../../test/support/resource_test'))

class PersonResourceTest < Minitest::Test
  include ResourceTest

  def test_details_does_not_request
    create(:person).details
    assert_requested(@api_stub, times: 0)
  end

  def test_collections_do_not_request
    create(:person).question_sets
    assert_requested(@api_stub, times: 0)
  end

  def test_valid_predicate
    person = create(:person, status: 'valid')
    assert person.valid?
    refute person.invalid?
  end

  def test_invalid_predicate
    person = create(:person, status: 'invalid')
    assert person.invalid?
    refute person.valid?
  end
end
