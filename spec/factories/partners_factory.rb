FactoryBot.define do
  factory :partner, class: "FloodRiskEngine::Partner" do
  end

  factory :partner_address, class: "FloodRiskEngine::Address" do
    premises            { Faker::Address.building_number }
    street_address      { Faker::Address.street_address }
    locality            { Faker::Address.street_address }
    city                { Faker::Address.city }
    postcode            { "BS1 5AH" }
  end

  factory :partner_contact, class: "FloodRiskEngine::Contact" do
    title               { 1 }
    full_name           { Faker::Name.name }
    suffix              { Faker::Name.suffix }
    date_of_birth       { rand(20..50).years.ago }
    position            { Faker::Company.profession }
    email_address       { generate(:random_email) }
    telephone_number    { Faker::PhoneNumber.phone_number }

    after(:create) { |object| object.address = create :partner_address }
  end

  factory :partner_with_contact, class: "FloodRiskEngine::Partner" do
    association :contact, factory: :partner_contact
  end
end
