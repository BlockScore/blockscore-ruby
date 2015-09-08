require 'erb'
require 'factory_girl'
require 'faker'

class JsonStrategy # From http://git.io/vT8kC
  def initialize
    @strategy = FactoryGirl.strategy_by_name(:build).new
  end

  delegate :association, to: :@strategy

  def result(evaluation, attrs = {})
    compiled = @strategy.result(evaluation)
    case compiled
    when BlockScore::Base then compiled.attributes.merge(attrs).to_json
    when Hash             then compiled.to_json
    else
      fail ArgumentError, "don't know how to handle type #{evaluation.class.inspect}"
    end
  end
end

FactoryGirl.register_strategy(:json, JsonStrategy)

MATCH_OPTIONS = %w(no_match match mismatch)
WATCHLISTS = %w(US_SDN US_DPL UK_HMC CA_OSI US_PLC AU_CON IZ_PEP)
MATCHING = %w(name date_of_birth ssn passport address county city state)

def random_match_result
  MATCH_OPTIONS[rand(0..2)]
end

def full_address
  street = Faker::Address.street_address
  city = Faker::Address.city
  country = Faker::Address.country

  "#{street} #{city} #{country}"
end

def resource_id
  Faker::Number.hexadecimal(24)
end

FactoryGirl.define do
  # Each response has this metadata so we define it as a trait
  trait :metadata do
    id { Faker::Base.regexify(/[0-9a-f]{24}/) }
    note ''
  end

  trait :timestamps do
    created_at { Faker::Time.backward(rand(2..5)).to_i }
    updated_at { created_at + (60 * 60 * 3) } # created_at + 3 hours
  end

  # We don't have create methods since we are creating hashes so we split out
  # our building instructions into a resource trait.
  trait :resource do
    skip_create
    initialize_with { attributes }
  end

  # Split out address into trait.
  trait :address do
    address_street1 { Faker::Address.street_address }
    address_street2 do
      Faker::Address.secondary_address if rand(1..2) == 1
    end
    address_city { Faker::Address.city }
    address_subdivision { Faker::Address.state_abbr }
    address_postal_code { Faker::Address.postcode }
    address_country_code { Faker::Address.country_code }
  end

  # Split out name into a trait.
  trait :name do
    name_first { Faker::Name.first_name }
    name_middle { nil }
    name_last { Faker::Name.last_name }
  end

  # Make :livemode and :testmode traits.
  trait(:livemode) { livemode true }
  trait(:testmode) { livemode false }

  # Person specific traits.
  trait(:status) do
    status do
      (rand(1..2) == 1) ? 'valid' : 'invalid'
    end
  end

  trait :document do
    document_type { 'ssn' }
    document_value { Faker::Number.number(4).to_s }
  end

  trait :birthday do
    birth_day { rand(1..28) }
    birth_month { rand(1..12) }
    birth_year { rand(1940..2014) }
  end

  trait(:phone_number) { phone_number Faker::PhoneNumber.phone_number }

  # Company Details factory.
  factory :company_details, class: Hash, traits: [:resource] do
    ofac { random_match_result }
    state { random_match_result }
    tax_id { random_match_result }
    address { random_match_result }
    incorp_date { random_match_result }
    country_code { random_match_result }
  end

  factory :person_details, class: Hash, traits: [:resource] do
    address { random_match_result }
    address_risk { random_match_result }
    identification { random_match_result }
    date_of_birth { random_match_result }
    ofac { random_match_result }
    pep { random_match_result }
  end

  # Candidate factory
  factory :candidate_params, class: 'BlockScore::Candidate' do
    ssn { '0000' }
    name
    address
  end

  factory :candidate, class: 'BlockScore::Candidate' do
    skip_create

    object { 'candidate' }
    metadata
    timestamps
    testmode
    ssn { Faker::Base.regexify(/\d{4}/) }
    passport { nil }
    date_of_birth { "19#{rand(40..99)}-#{rand(1..12)}-#{rand(1..28)}" }
    name
    address
  end

  # Company Factory
  factory :company_params, class: 'BlockScore::Company' do
    entity_name { Faker::Company.name }
    tax_id { Faker::Base.regexify(/\d{9}/) }
    incorporation_country_code { Faker::Address.country_code }
    incorporation_type { 'corporation' }
    address
  end

  factory :company, class: 'BlockScore::Company' do
    skip_create

    object { 'company' }
    metadata
    timestamps
    status
    testmode
    entity_name { Faker::Company.name }
    tax_id { Faker::Base.regexify(/\d{9}/) }
    incorporation_day { rand(1..28) }
    incorporation_month { rand(1..12) }
    incorporation_year { rand(1900..2014) }
    incorporation_state { Faker::Address.state_abbr }
    incorporation_country_code { Faker::Address.country_code }
    incorporation_type { 'corporation' }
    dbas { Faker::Company.name }
    registration_number { Faker::Base.regexify(/\d{9}/) }
    email { Faker::Internet.email }
    url { Faker::Internet.url }
    phone_number
    ip_address { Faker::Internet.ip_v4_address }
    address
    details { build(:company_details) }
  end

  factory :person_params, class: 'BlockScore::Person' do
    name
    document
    address
    birthday
    phone_number
    ip_address { Faker::Internet.ip_v4_address }
  end

  factory :person, class: 'BlockScore::Person' do
    skip_create
    transient { question_sets_count 1 }

    object { 'person' }
    metadata
    timestamps
    status
    livemode
    name
    phone_number
    ip_address { Faker::Internet.ip_v4_address }
    birthday
    address
    document
    details { build(:person_details) }

    question_sets do
      question_sets_count.times.map do
        resource_id
      end
    end

    initialize_with { new(attributes) }
  end

  # QuestionSet Factory

  factory :question_set_params, class: 'BlockScore::QuestionSet' do
    person_id { resource_id }
  end

  factory :question_set, class: 'BlockScore::QuestionSet' do
    skip_create

    object { 'question_set' }
    metadata
    timestamps
    testmode
    person_id { resource_id }
    score { rand * 100 }
    expired { false }
    time_limit { rand(120..360) }
    questions { 5.times.collect { build(:question) } }
  end

  factory :question, class: Hash, traits: [:resource] do
    sequence(:id)
    answers { 5.times.collect { build(:answer) } }
  end

  factory :answer, class: Hash, traits: [:resource] do
    sequence(:id)
    answer { Faker::Lorem.word }
  end

  factory :watchlist, class: Hash, traits: [:resource] do
    livemode
    searched_lists { WATCHLISTS.sample(2) }
    count { rand(1..5) }
    matches { build_list(:match, count) }
  end

  factory :match, class: Hash, traits: [:resource] do
    id { Faker::Base.regexify(/[0-9a-f]{24}/) }
    notes ''
    watchlist_name { WATCHLISTS.sample }
    entry_type { 'individual' }
    matching_info { MATCHING.sample(rand(2..4)) }
    confidence { rand }
    url { nil }
    title { nil }
    name_full { Faker::Name.name }
    alternate_names { Faker::Name.name + '; ' + Faker::Name.name }
    date_of_birth { Faker::Base.regexify(/19\d{2}-01-01/) }
    passport { nil }
    ssn { Faker::Base.regexify(/\d{4}/) }
    address_street1 { Faker::Address.street_address }
    address_street2 do
      Faker::Address.secondary_address if rand(1..2) == 1
    end
    address_city { Faker::Address.city }
    address_state { Faker::Address.state_abbr }
    address_postal_code { Faker::Address.postcode }
    address_country_code { Faker::Address.country_code }
    address_raw { full_address }
    names { build_list(:match_name, rand(1..5)) }
    births { build_list(:match_birth, rand(1..5)) }
    documents { build_list(:match_document, rand(1..5)) }
    addresses { build_list(:match_address, rand(1..5)) }
  end

  factory :match_address, class: Hash, traits: [:resource] do
    address_street1 { Faker::Address.street_address }
    address_street2 do
      Faker::Address.secondary_address if rand(1..2) == 1
    end
    address_city { Faker::Address.city }
    address_state { Faker::Address.state_abbr }
    address_postal_code { Faker::Address.postcode }
    address_country_code { Faker::Address.country_code }
    address_full { full_address }
  end

  factory :match_birth, class: Hash, traits: [:resource] do
    birthday
    birth_day_end { nil }
    birth_month_end { nil }
    birth_year_end { nil }
  end

  factory :match_document, class: Hash, traits: [:resource] do
    document
    document_country_code { Faker::Address.country_code }
  end

  factory :match_name, class: Hash, traits: [:resource] do
    name_primary { false }
    name_full { Faker::Name.name }
    name_strength { %w(low medium high).sample }
  end

  # We can do this because the error type is determined by the
  # HTTP response code.
  factory :blockscore_error, class: Hash, traits: [:resource] do
    transient do
      error_type 'api_error'
    end

    error { create(error_type.to_s) }
  end

  factory :api_error, class: Hash, traits: [:resource] do
    message { 'An error occurred.' }
    type { 'api_error' }
    code { '0' }
    param { nil }
  end

  factory :authentication_error, class: Hash, traits: [:resource] do
    message { 'The provided API key is invalid.' }
    type { 'authentication_error' }
    code { '0' }
    param { nil }
  end

  factory :invalid_request_error, class: Hash, traits: [:resource] do
    message { 'One of more parameters is invalid.' }
    type { 'invalid_request_error' }
    code { '0' }
    param { 'name_first' }
  end

  factory :not_found_error, class: Hash, traits: [:resource] do
    message { 'Person with ID ab973197319713ba could not be found' }
    type { 'not_found_error' }
    code { '0' }
    param { nil }
  end
end
