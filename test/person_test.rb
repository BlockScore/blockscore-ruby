require File.expand_path(File.join(__FILE__, '../test_helper'))

class PersonResourceTest < Minitest::Test
  include ResourceTest

  def test_details_access
    person = create_person
    details = person.details

    assert_respond_to details, :address
    assert_respond_to details, :address_risk
    assert_respond_to details, :identification
    assert_respond_to details, :date_of_birth
    assert_respond_to details, :ofac
    assert_respond_to details, :pep
  end
end
