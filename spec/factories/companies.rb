require 'factory_girl'
require 'faker'

FactoryGirl.define do
  factory :company, class: 'BlockScore::Company' do
    entity_name                 { Faker::Company.name }
    tax_id                      { '000000000' }
    incorporation_country_code  { Faker::Address.country_code }
    incorporation_type          { %w(corporation llc partnership sp other).sample }
    address_street1             { Faker::Address.street_address }
    address_city                { Faker::Address.city }
    address_subdivision         { Faker::Address.state_abbr }
    address_postal_code         { Faker::Address.postcode }
    address_country_code        { Faker::Address.country_code }

    trait :invalid do
      tax_id { '000000001' }
    end

    factory :valid_company
    factory :invalid_company, traits: [:invalid]
  end
end
