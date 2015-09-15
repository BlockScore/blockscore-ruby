require 'factory_girl'
require 'faker'

FactoryGirl.define do
  factory :person, class: 'BlockScore::Person' do
    name_first            { Faker::Name.first_name }
    name_last             { Faker::Name.last_name }
    document_type         { 'ssn' }
    document_value        { '0000' }
    birth_day             { 12 }
    birth_month           { Faker::Date.backward(365 * 100).month }
    birth_year            { Faker::Date.backward(365 * 100).year }
    address_street1       { Faker::Address.street_address }
    address_city          { Faker::Address.city }
    address_subdivision   { Faker::Address.state_abbr }
    address_postal_code   { Faker::Address.postcode }
    address_country_code  { 'US' }

    trait :invalid do
      document_value { '0001' }
    end

    factory :valid_person
    factory :invalid_person, traits: [:invalid]
  end
end
