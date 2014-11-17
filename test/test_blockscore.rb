require File.join(File.dirname(__FILE__), 'helper')

class TestBlockScore < Test::Unit::TestCase
  # If you'd like to run the test suite, fill in your API key,
  # a person ID, a question set ID, a company ID, and a candidate ID below.
  @api_key = ""

  @@person_id = ""
  @@question_set_id = ""
  @@company_id = ""
  @@candidate_id = ""

  @@client = BlockScore::Client.new(@api_key)

  context "a watchlist" do
    should "return search watchlists" do
      response = @@client.watchlist.search(@@candidate_id)
      assert_equal 200, response.code
    end
  end

  context "a candidate" do
    should "return create a candidate" do
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
      response = @@client.candidate.create(watchlist_params)
      assert_equal 201, response.code
    end

    should "return edit a candidate" do
      watchlist_params = {
        :date_of_birth => "1945-05-08",
        :name_middle => "Jones"
      }
      response = @@client.candidate.edit(@@candidate_id, watchlist_params)
      assert_equal 200, response.code
    end

    should "return retrieve a candidate" do
      response = @@client.candidate.retrieve(@@candidate_id)
      assert_equal 200, response.code
    end

    should "return a list of candidates" do
      response = @@client.candidate.all
      assert_equal 200, response.code
    end

    should "return a history of a candidate" do
      response = @@client.candidate.history(@@candidate_id)
      assert_equal 200, response.code
    end

    should "return the hits of a candidate" do
      response = @@client.candidate.hits(@@candidate_id)
      assert_equal 200, response.code
    end

    should "return delete a candidate" do 
      response = @@client.candidate.delete(@@candidate_id)
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
        :incorporation_day => 25,
        :incorporation_month => 8,
        :incorporation_year => 1980,
        :incorporation_state => "DE",
        :incorporation_country_code => "US",
        :incorporation_type => "corporation",
        :dbas => "BitRemit",
        :registration_number => "123123123",
        :email => "test@example.com",
        :url => "https://blockscore.com",
        :phone_number => "6505555555",
        :ip_address => "67.160.8.182",
        :address_street1 => "1 Infinite Loop",
        :address_street2 => nil,
        :address_city => "Cupertino",
        :address_subdivision => "CA",
        :address_postal_code => "95014",
        :address_country_code => "US"
      }

      response = @@client.company.create(company_params)

      assert_equal 201, response.code
    end
  end

  context "a person" do
    should "return a list of people" do
      response = @@client.people.all
      assert_equal 200, response.code
    end

    should "return count = 2 people" do
      response = @@client.people.all(count = 2)
      assert_equal 200, response.code
    end

    should "return count=2 offset=2 people" do
      response = @@client.people.all(count = 2, offset = 2)
      assert_equal 200, response.code
    end

    should "return a single people" do
      response = @@client.people.retrieve(@@person_id)
      assert_equal 200, response.code
    end

    should "return create a person" do
      people_params = {
        :birth_day => 1,
        :birth_month => 1,
        :birth_year => 1975,
        :document_type => "ssn",
        :document_value => "0000",
        :name_first => "John",
        :name_middle => "P",
        :name_last => "Doe",
        :address_street1 => "1 Infinite Loop",
        :address_street2 => nil,
        :address_city => "Cupertino",
        :address_subdivision => "CA",
        :address_postal_code => "95014",
        :address_country_code => "US"
      }

      response = @@client.people.create(people_params)

      assert_equal 201, response.code
    end
  end

  context "a question set" do
    should "return create a question set" do
      response = @@client.question_set.create(@@person_id)
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
