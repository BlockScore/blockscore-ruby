require 'simplecov'
require 'test/unit'
require 'test/unit/active_support'
require 'active_support'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'blockscore'

class TestClient
  @@api_key = 'sk_test_a1ed66cc16a7cbc9f262f51869da31b3'
  @@client ||= BlockScore::Client.new(@@api_key)
  
  class << self
    def client
      @@client
    end
    
    def create_candidate
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
      @@client.candidates.create(watchlist_params)
    end

    def create_company
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

      @@client.companies.create(company_params)
    end
    
    def create_person
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

      @@client.people.create(people_params)
    end

    def create_question_set
      person = create_person
      @@client.question_sets.create(person["id"])
    end
  end
end

