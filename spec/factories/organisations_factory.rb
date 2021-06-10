FactoryBot.define do
  factory :organisation, class: "FloodRiskEngine::Organisation" do
    org_type            { 0 }
    name                { Faker::Company.name }
    registration_number { Faker::Number.number(digits: 8) }

    after(:build) do |object|
      object.contact = FloodRiskEngine::Contact.create(contact_type: :establishment_or_undertaking)
    end

    # A trait to create a blank Organisation for each Type
    # One trait per type named in format : as_xxx e.g   as_local_authority, as_limited_liability_partnership etc
    FloodRiskEngine::Organisation.org_types.each_key do |ot|
      trait :"as_#{ot}" do
        org_type            { ot.to_s }
        name                { "" }
      end
    end

    trait :with_partners do
      after(:create) do |object|
        (0..rand(4)).each { |_i| object.partners << create(:partner_with_contact) }
      end
    end
  end
end
