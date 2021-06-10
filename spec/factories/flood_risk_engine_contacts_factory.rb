FactoryBot.define do
  factory :flood_risk_engine_contact, class: "FloodRiskEngine::Contact" do
    title             { 1 }
    full_name         { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    position          { Faker::Company.profession }
    email_address     { Faker::Internet.email }
    suffix            { Faker::Name.suffix }
    date_of_birth     { 30.years.ago }
    telephone_number  { Faker::PhoneNumber.phone_number }
  end
end
