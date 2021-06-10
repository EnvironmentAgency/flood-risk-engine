FactoryBot.define do
  sequence(:exemption_code) { |n| "FRA_RSPEC_#{n}" }

  factory :exemption, class: FloodRiskEngine::Exemption do
    code        { generate(:exemption_code) }
    summary     { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
  end
end
