require File.expand_path(File.join(__FILE__, '../../test_helper'))

class PersonResourceTest < Minitest::Test
  include ResourceTest

  def test_details_does_not_request
    create_person.details
    assert_requested(@api_stub, times: 1) # @person creation in setup
  end

  def test_collections_do_not_request
    create_person.question_sets
    assert_requested(@api_stub, times: 1) # once when Person was created.
  end

  def test_valid_predicate
    person = BlockScore::Person.new(create(:person, status: 'valid'))
    assert person.valid?
    refute person.invalid?
  end

  def test_invalid_predicate
    person = BlockScore::Person.new(create(:person, status: 'invalid'))
    assert person.invalid?
    refute person.valid?
  end
end
