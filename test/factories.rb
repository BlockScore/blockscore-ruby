require 'erb'
require 'factory_girl'
require 'faker'

class JsonStrategy # From http://git.io/vT8kC
  def initialize
    @strategy = FactoryGirl.strategy_by_name(:create).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    @strategy.result(evaluation).to_json
  end
end

FactoryGirl.register_strategy(:json, JsonStrategy)

MATCH_OPTIONS = %w(no_match match mismatch)

# Just a subset of the possible options.
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
  factory :company_details, :class => Hash, :traits => [:resource] do
    ofac { random_match_result }
    state { random_match_result }
    tax_id { random_match_result }
    address { random_match_result }
    incorp_date { random_match_result }
    country_code { random_match_result }
  end

  factory :person_details, :class => Hash, :traits => [:resource] do
    address { random_match_result }
    address_risk { random_match_result }
    identification { random_match_result }
    date_of_birth { random_match_result }
    ofac { random_match_result }
    pep { random_match_result }
  end

  # Candidate factory
  factory :candidate_params, :class => Hash, :traits => [:resource] do
    ssn { Faker::Base.regexify(/\d{4}/) }
    name
    address
  end

  factory :candidate, :class => Hash, :traits => [:resource] do
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
  factory :company_params, :class => Hash, :traits => [:resource] do
    entity_name { Faker::Company.name }
    tax_id { Faker::Base.regexify(/\d{9}/) }
    incorporation_country_code { Faker::Address.country_code }
    incorporation_type { 'corporation' }
    address
  end

  factory :company, :class => Hash, :traits => [:resource] do
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

  factory :person_params, :class => Hash, :traits => [:resource] do
    name
    document
    address
    birthday
    phone_number
    ip_address { Faker::Internet.ip_v4_address }
  end

  factory :person, :class => Hash, :traits => [:resource] do
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
    question_set_ids do
      rand(0..5).times.collect { Faker::Base.regexify(/\d{24}/) }
    end
  end

  # QuestionSet Factory

  factory :question_set_params, :class => Hash, :traits => [:resource] do
    person_id { Faker::Base.regexify(/\d{24}/) }
  end

  factory :question_set, :class => Hash, :traits => [:resource] do
    object { 'question_set' }
    metadata
    timestamps
    testmode
    person_id { Faker::Base.regexify(/\d{24}/) }
    score { rand * 100 }
    expired { false }
    time_limit { rand(120..360) }
    questions { 5.times.collect { build(:question) } }
  end

  factory :question, :class => Hash, :traits => [:resource] do
    sequence(:id)
    answers { 5.times.collect { build(:answer) } }
  end

  factory :answer, :class => Hash, :traits => [:resource] do
    sequence(:id)
    answer { Faker::Lorem.word }
  end

  factory :watchlist, :class => Hash, :traits => [:resource] do
    livemode
    searched_lists { WATCHLISTS.sample(2) }
    count { rand(1..5) }
    matches { build_list(:match, count) }
  end

  factory :match, :class => Hash, :traits => [:resource] do
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

  factory :match_address, :class => Hash, :traits => [:resource] do
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

  factory :match_birth, :class => Hash, :traits => [:resource] do
    birthday
    birth_day_end { nil }
    birth_month_end { nil }
    birth_year_end { nil }
  end

  factory :match_document, :class => Hash, :traits => [:resource] do
    document
    document_country_code { Faker::Address.country_code }
  end

  factory :match_name, :class => Hash, :traits => [:resource] do
    name_primary { false }
    name_full { Faker::Name.name }
    name_strength { %w(low medium high).sample }
  end

  # We can do this because the error type is determined by the
  # HTTP response code.
  factory :blockscore_error, :class => Hash, :traits => [:resource] do
    error { create(:error_contents) }
  end

  # Easily create the desired nesting for error objects.
  factory :error_contents, :class => Hash, :traits => [:resource] do
    message { 'An error occurred.' }
    type { 'invalid_request_error' }
    code { '0' }
    param { 'name_first' }
  end
end
