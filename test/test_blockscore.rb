require File.join(File.dirname(__FILE__), 'helper')

class TestBlockScore < Test::Unit::TestCase
  # If you'd like to run the test suite, fill in your API key,
  # a verification ID, a question set ID, a company ID, and a watchlist candidate ID below.
  @version = 3
  @api_key = "sk_test_da5803c774d597b24aa2007d7e244686"

  @@verification_id = ""
  @@question_set_id = ""
  @@company_id = ""
  @@watchlist_candidate_id = "53e004a43463330002eb0500"

  @@client = BlockScore::Client.new(@api_key, version = @version)

  context "a watchlist candidate" do
    should "return create a watchlist candidate" do
      watchlist_params = {
       :note => "12341234",
       :ssn => "0001",
       :date_of_birth => "1940-08-11",
       :name_first => "John",
       :name_middle => "",
       :name_last => "Bredenkamp",
       :address_street1 => "1 Infinite Loop",
       :address_city => "Cupertino",
       :address_country_code => "US"
      }
      response = @@client.watchlist_candidate.create(watchlist_params)
      assert_equal 201, response.code
    end

    should "return edit a watchlist candidate" do
      watchlist_params = {
        :date_of_birth => "1945-05-08",
        :name_middle => "Jones"
      }
      response = @@client.watchlist_candidate.edit(@@watchlist_candidate_id, watchlist_params)
      assert_equal 200, response.code
    end

    should "return retrieve a watchlist candidate" do
      response = @@client.watchlist_candidate.retrieve(@@watchlist_candidate_id)
      assert_equal 200, response.code
    end

    should "return a list of wachlist candidates" do
      response = @@client.watchlist_candidate.all
      assert_equal 200, response.code
    end

    should "return a history of a wachlist candidate" do
      response = @@client.watchlist_candidate.history(@@watchlist_candidate_id)
      assert_equal 200, response.code
    end

    should "return the hits of a wachlist candidate" do
      response = @@client.watchlist_candidate.hits(@@watchlist_candidate_id)
      assert_equal 200, response.code
    end

    should "return delete a watchlist candidate" do 
      response = @@client.watchlist_candidate.delete(@@watchlist_candidate_id)
      assert_equal 200, response.code
    end

  end

  context "a company" do
    should "return a list of companies" do
      response = @@client.company.all
      assert_equal 200, response.code
    end

    should "return count = 2 companies" do
      response = @@client.company.all(count = 2)
      assert_equal 200, response.code
    end

    should "return count=2 offset=2 companies" do
      response = @@client.company.all(count = 2, offset = 2)
      assert_equal 200, response.code
    end

    should "return a single company" do
      response = @@client.company.retrieve(@@company_id)
      assert_equal 200, response.code
    end

    should "return create a company" do
      company_params = {
        :entity_name => "BlockScore",
        :tax_id => "123410000",
        :incorp_date => "1980-08-25",
        :incorp_state => "DE",
        :incorp_country_code => "US",
        :incorp_type => "corporation",
        :dbas => "BitRemit",
        :registration_number => "123123123",
        :email => "test@example.com",
        :url => "https://blockscore.com",
        :phone_number => "6505555555",
        :ip_address => "67.160.8.182",
        :address => {
          :street1 => "1 Infinite Loop",
          :street2 => nil,
          :city => "Cupertino",
          :state => "CA",
          :postal_code => "95014",
          :country_code => "US"
        }
      }

      response = @@client.company.create(company_params)

      assert_equal 201, response.code
    end
  end

  context "a verification" do
    should "return a list of verifications" do
      response = @@client.verification.all
      assert_equal 200, response.code
    end

    should "return count = 2 verifications" do
      response = @@client.verification.all(count = 2)
      assert_equal 200, response.code
    end

    should "return count=2 offset=2 verifications" do
      response = @@client.verification.all(count = 2, offset = 2)
      assert_equal 200, response.code
    end

    should "return a single verification" do
      response = @@client.verification.retrieve(@@verification_id)
      assert_equal 200, response.code
    end

    should "return create a verification" do
      verification_params = {
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
          :country_code => "US"
        }
      }

      response = @@client.verification.create(verification_params)

      assert_equal 201, response.code
    end
  end

  context "a question set" do
    should "return create a question set" do
      response = @@client.question_set.create(@@verification_id)
      assert_equal 201, response.code
    end

    should "return a single question set" do
      response = @@client.question_set.retrieve(@@question_set_id)
      assert_equal 200, response.code
    end

    should "return a list of question sets" do
      response = @@client.question_set.all
      assert_equal 200, response.code
    end

    should "return count = 2" do
      response = @@client.question_set.all(count = 2)
      assert_equal 200, response.code
    end

    should "return count = 2 offset = 2" do
      response = @@client.question_set.all(count = 2, offset = 2)
      assert_equal 200, response.code
    end

    should "return a score" do
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

      response = @@client.question_set.score(@@question_set_id, @answers)

      assert_equal 201, response.code
    end
  end
end
