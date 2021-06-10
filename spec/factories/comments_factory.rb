FactoryBot.define do
  factory :comment, class: "FloodRiskEngine::Comment" do
    user_id     { nil }
    association :commentable, factory: :enrollment_exemption
    content     { Faker::Lorem.paragraph }
    event       { Faker::Lorem.sentence }

    created_at do
      from = 1.year.ago.to_f
      Time.zone.at(from + rand * (Time.zone.now.to_f - from))
    end

    trait :with_user_id do
      user_id { rand(10) }
    end
  end
end
