require 'factory_girl'
require 'faker'

FactoryGirl.define do
  factory :candidate, class: 'BlockScore::Candidate' do
    ssn                  { '0000' }
    date_of_birth        { Faker::Date.backward(365 * 100).to_s }
    name_first           { Faker::Name.first_name }
    name_last            { Faker::Name.last_name }
    address_street1      { Faker::Address.street_address }
    address_city         { Faker::Address.city }
    address_country_code { Faker::Address.country_code }

    # TODO: Update to use '0010' AND style option set
    trait :watched do
      ssn                  { nil }
      date_of_birth        { nil }
      name_first           { 'John' }
      name_last            { 'Bredenkamp' }
      address_street1      { nil }
      address_city         { nil }
      address_country_code { nil }
    end

    factory :watched_candidate, traits: [:watched]
  end
end
