require File.expand_path(File.join(__FILE__, '../../test_helper'))

class PersonResourceTest < Minitest::Test
  include ResourceTest

  DETAIL_KEYS = [
    :address, :address_risk, :identification, :date_of_birth, :ofac, :pep
  ]

  context 'person specific tests' do
    setup do
      @person = create_person
    end

    should 'details hash should contain all of the correct keys' do
      details = @person.details
      DETAIL_KEYS.each do |key|
        assert_respond_to details, key
      end
    end

    should 'details hash should be an OpenStruct object' do
      assert @person.details.kind_of?(OpenStruct)
    end

    should 'question_sets should be of kind BlockScore::Collection' do
      assert @person.question_sets.kind_of?(BlockScore::Collection)
    end

    should 'accessing the question_sets collection should not cause an extra network request' do
      @person.question_sets
      assert_requested(@api_stub, times: 1) # once when Person was created.
    end
  end
end
