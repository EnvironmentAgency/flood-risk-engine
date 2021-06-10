require "uk_postcode"

FactoryBot.define do
  factory :address, class: "FloodRiskEngine::Address" do
    premises            { Faker::Address.building_number }
    street_address      { Faker::Address.street_address }
    locality            { Faker::Address.city_prefix }
    city                { Faker::Address.city }
    postcode            { "BS1 5AH" }
    county_province_id  { 1 }
    country_iso         { Faker::Address.country_code }
    address_type        { 1 }
    organisation        { Faker::Company.name }
    state_date          { 1.year.ago }
    blpu_state_code     { Faker::Lorem.characters(number: 10) }
    postal_address_code { Faker::Lorem.characters(number: 10) }
    logical_status_code { Faker::Lorem.characters(number: 10) }

    trait :site do
      address_type { 2 }
    end

    trait :primary do
      address_type { 0 }
    end
  end

  factory :simple_address, class: "FloodRiskEngine::Address" do
    premises            { Faker::Address.building_number }
    street_address      { Faker::Address.street_address }
    locality            { Faker::Address.city_prefix }
    city                { Faker::Address.city }
    postcode            { "BS1 5AH" }
  end

  factory :address_services, parent: :address
end
