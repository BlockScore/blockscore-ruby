require 'helper'

class TestBlockScore < Test::Unit::TestCase
  context "a verification" do
    setup do
      @blockscore = BlockScore::Client.new("sk_test_74d0a2e9649c8eed8bbef051666e1aa2", version = 2)
    end

    should "return a list of verifications" do
      assert_equal 200, @blockscore.get_verifications.code
    end

    should "return a single verification" do
      assert_equal 200, @blockscore.get_verification("526781407e7b0ace47000001").code
    end

    should "return create a verification" do
      @json_representation = {
        "type" => "us_citizen",
        "date_of_birth" => "1993-08-23",
        "identification" => {
          "ssn" => "0000"
        },
        "name" => {
          "first" => "Alain",
          "middle" => nil,
          "last" => "Meier"
        },
        "address" => {
          "street1" => "1 Infinite Loop",
          "street2" => nil,
          "city" => "Cupertino",
          "state" => "CA",
          "postal_code" => "95014",
          "country" => "US"
        }
      }

      assert_equal 201, @blockscore.create_verification(@json_representation).code
    end
  end
end
