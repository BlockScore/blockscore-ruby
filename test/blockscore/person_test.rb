require File.expand_path(File.join(__FILE__, '../../test_helper'))

class PersonResourceTest < Minitest::Test
  include ResourceTest

  DETAIL_KEYS = [
    :address, :address_risk, :identification, :date_of_birth, :ofac, :pep
  ]

  def test_details_keys
    details = create_person.details
    DETAIL_KEYS.each do |key|
      assert_respond_to details, key
    end
  end

  def test_open_struct_details
    assert create_person.details.kind_of?(OpenStruct)
  end

  def test_details_does_not_request
    create_person.details
    assert_requested(@api_stub, times: 1) # @person creation in setup
  end

  def test_question_sets_are_collections
    assert create_person.question_sets.kind_of?(BlockScore::Collection)
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
