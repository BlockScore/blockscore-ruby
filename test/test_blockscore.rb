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
      assert_equal 200, @blockscore.get_verification("53099a636274639ebb0e0000").code
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

    should "return create a question set" do
      @json_representation = {
        "verification_id" => "53099a636274639ebb0e0000"
      }

      assert_equal 201, @blockscore.create_question_set(@json_representation).code
    end

    # should "return a single question set" do
    #   assert_equal 200, @blockscore.get_question_set("53099c5f6274639ebb7e0000").code
    # end

    should "return a score for the question set" do
      @json_representation = {
        "verification_id" => "53099a636274639ebb0e0000",
        "question_set_id" => "53099c5f6274639ebb7e0000",
        "answers" => [
          {
            "question_id" => 1,
            "answer_id" => 1
          },
          {
            "question_id" => 2,
            "answer_id" => 1
          },
          {
            "question_id" => 3,
            "answer_id" => 1
          },
          {
            "question_id" => 4,
            "answer_id" => 1
          },
          {
            "question_id" => 5,
            "answer_id" => 1
          }
        ]
      }

      assert_equal 201, @blockscore.score_question_set(@json_representation).code
    end
  end
end
