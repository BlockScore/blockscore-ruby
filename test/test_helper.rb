require 'active_support/core_ext/string/inflections'
require 'factory_girl'
require 'faker'
require 'simplecov'
require 'test/unit'
require 'webmock/test_unit'

require File.join(File.dirname(__FILE__), 'factories')

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'blockscore'

URL_REGEXP = %r([\w\d]*:@api\.blockscore\.com(:443)?/(?<resource>\w+)/(?<id>[\w\d]*)?/?(?<action>hits|history|score)?)

WebMock.disable_net_connect!(:allow => 'codeclimate.com')

HEADERS = {
  'Accept' => 'application/vnd.blockscore+json;version=4',
  'User-Agent' => 'blockscore-ruby/4.1.0 (https://github.com/BlockScore/blockscore-ruby)',
  'Content-Type' => 'application/json'
}

def index_response(resource, count)
  {
    :total_count => count,
    :has_more => false,
    :object => 'list',
    :data => FactoryGirl.build_list(resource.to_sym, count)
  }.to_json
end

def resource_from_uri(uri)
  uri.to_s.split('/').last.singularize.to_sym
end

# configure test-unit for FactoryGirl
class Test::Unit::TestCase
  include FactoryGirl::Syntax::Methods

  setup do

    stub_request(:any, /.*api\.blockscore\.com\/.*/).
      with(headers: HEADERS).
      to_return do |request|
        match = URL_REGEXP.match request.uri.to_s
        factory_name = resource_from_uri(match[:resource])

        # id and action might be "" (empty string)
        id = (match[:id].nil? || match[:id].empty?) ? nil : match[:id]
        action = (match[:action].nil? || match[:action].empty?) ? nil : match[:action]

        factory = FactoryGirl.factories[factory_name]
        if factory.nil?
          raise ArgumentError, "could not find factory #{factory_name.inspect}."
        end

        status = 200 # will only change on CREATEs
        if id == nil && request.method == :get
          # index
          body = index_response(factory_name, 5)
        elsif action == 'history'
          body = FactoryGirl.build_list(factory_name, 5).to_json
        elsif action == 'hits'
          body = index_response(factory_name, 5)
        else
          status = 201 if request.method == :post && action.nil?
          body = FactoryGirl.json(factory_name)
        end

        { :status => status, :body => body, :headers => {} }
      end

  end
end

# Convert a resource into the corresponding BlockScore class.
def resource_to_class(resource)
  "BlockScore::#{resource.camelcase}".constantize
end

module ResourceTest
  def self.included(base)
    base.mattr_accessor :resource
    base.resource = base.to_s[/^(\w+)ResourceTest/, 1].underscore
  end

  def test_create_resource
    response = TestClient.send(:"create_#{resource}")
    assert_equal response.class, resource_to_class(resource)
  end

  def test_retrieve_resource
    r = TestClient.send(:"create_#{resource}")
    response = resource_to_class(resource).send(:retrieve, r.id)
    assert_equal resource, response.object
  end

  def test_list_resource
    response = resource_to_class(resource).send(:all)
    assert_equal Array, response.class
  end

  def test_list_resource_with_count
    msg = "List #{resource} with count = 2 failed"
    response = resource_to_class(resource).send(:all, {:count => 2})
    assert_equal Array, response.class, msg
  end

  def test_list_resource_with_count_and_offset
    msg = "List #{resource} with count = 2 and offset = 2 failed"
    response = resource_to_class(resource).
      send(:all, {:count => 2, :offset => 2})
    assert_equal Array, response.class, msg
  end
end

class TestClient
  @@api_key = 'sk_test_a1ed66cc16a7cbc9f262f51869da31b3'
  BlockScore.api_key(@@api_key)

  class << self
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
      BlockScore::Candidate.create(watchlist_params)
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

      BlockScore::Company.create(company_params)
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

      BlockScore::Person.create(people_params)
    end

    def create_question_set
      person = create_person
      person.question_set.create
    end
  end
end
