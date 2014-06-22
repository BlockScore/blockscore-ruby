require_relative './helper'

class TestBlockScore < Test::Unit::TestCase
  context "a verification" do
    setup do
      # If you'd like to run the test suite, fill in your API key,
      # a verification ID and a question set ID below.
      @client = BlockScore::Client.new("Your API key", version = 2)

      @verification_id = "Your verification ID"
      @question_set_id = "Your question set ID"
    end

    should "return a list of verifications" do
      response = @client.verification.all
      assert_equal 200, response.code
    end

    should "return count = 2 verifications" do
      response = @client.verification.all(count = 2)
      assert_equal 200, response.code
    end

    should "return count=2 offset=2 verifications" do
      response = @client.verification.all(count = 2, offset = 2)
      assert_equal 200, response.code
    end

    should "return a single verification" do
      response = @client.verification.retrieve(@verification_id)
      assert_equal 200, response.code
    end

    should "return create a verification" do
      verification_params = {
        :type => "us_citizen",
        :date_of_birth => "1975-01-01",
        :identification => {
          :ssn => "0000"
        },
        :name => {
          :first => "John",
          :middle => "P",
          :last => "Doe"
        },
        :address => {
          :street1 => "1 Infinite Loop",
          :street2 => nil,
          :city => "Cupertino",
          :state => "CA",
          :postal_code => "95014",
          :country => "US"
        }
      }

      response = @client.verification.create(verification_params)

      assert_equal 201, response.code
    end

    should "return create a question set" do
      response = @client.question_set.create(@verification_id)
      assert_equal 201, response.code
    end

    should "return a single question set" do
      response = @client.question_set.retrieve(@question_set_id, @verification_id)
      assert_equal 201, response.code
    end

    should "return a list of question sets" do
      response = @client.question_set.all
      assert_equal 200, response.code
    end

    should "return count = 2 question sets" do
      response = @client.question_set.all(count = 2)
      assert_equal 200, response.code
    end

    should "return count = 2 offset = 2 question sets" do
      response = @client.question_set.all(count = 2, offset = 2)
      assert_equal 200, response.code
    end

    should "return a score for the question set" do
      @answers = [
          {
            :question_id => 1,
            :answer_id => 1
          },
          {
            :question_id => 2,
            :answer_id => 1
          },
          {
            :question_id => 3,
            :answer_id => 1
          },
          {
            :question_id => 4,
            :answer_id => 1
          },
          {
            :question_id => 5,
            :answer_id => 1
          }
        ]

      response = @client.question_set.score(
                                @verification_id,
                                @question_set_id,
                                @answers
                              )

      assert_equal 201, response.code
    end
  end
end
