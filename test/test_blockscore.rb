require 'helper'

class TestBlockScore < Test::Unit::TestCase
  context "a verification" do
    setup do
      @blockscore = BlockScore::Client.new("YOUR_API_KEY", version = 2)
    end

    should "return a list of verifications" do
      assert_equal 200, @blockscore.verification.all.code
    end

    should "return count = 2 verifications" do
      assert_equal 200, @blockscore.verification.all(count=2).code
    end

    should "return count=2 offset=2 verifications" do
      assert_equal 200, @blockscore.verification.all(count=2, offset=2).code
    end

    should "return a single verification" do
      assert_equal 200, @blockscore.verification.retrieve("YOUR_VERIFICATION_ID").code
    end

    should "return create a verification" do
      @type = "us_citizen"
      @date_of_birth = "1975-01-01"
      
      @identification = {
        ssn: "0000"
      }
      
      @name = {
        first: "John",
        middle: nil,
        last: "Doe"
      }

      @address = {
        street1: "1 Infinite Loop",
        street2: nil,
        city: "Cupertino",
        state: "CA",
        postal_code: "95014",
        country: "US"
      }

      assert_equal 201, @blockscore.verification
                              .create(
                                @type,
                                @date_of_birth,
                                @identification, 
                                @name, 
                                @address
                              ).code
    end

    should "return create a question set" do
      @verification_id = "YOUR_VERIFICATION_ID"

      assert_equal 201, @blockscore.question_set.create(@verification_id).code
    end

    should "return a score for the question set" do
      @verification_id = "YOUR_VERIFICATION_ID"
      @question_set_id = "YOUR_QUESTION_SET_ID"
      @answers = [
          {
            question_id: 1,
            answer_id: 1
          },
          {
            question_id: 2,
            answer_id: 1
          },
          {
            question_id: 3,
            answer_id: 1
          },
          {
            question_id: 4,
            answer_id: 1
          },
          {
            question_id: 5,
            answer_id: 1
          }
        ]

      assert_equal 201, @blockscore.question_set
                              .score(
                                @verification_id,
                                @question_set_id,
                                @answers
                              ).code
    end
  end
end
