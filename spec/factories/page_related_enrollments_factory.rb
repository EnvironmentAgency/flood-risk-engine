# A suite of Enrollments that enable you to jump straight to a particular page in the journey

FactoryBot.define do
  factory :page_user_type, parent: :enrollment do
    step { :user_type }

    trait :with_primary_address do
      after(:create) do |object|
        object.organisation.primary_address = create(:simple_address)
        object.save!
      end
    end
  end

  # Paths

  # Individual

  factory :page_individual_name, parent: :page_user_type, traits: %i[with_exemption with_individual] do
    step { :individual_name }
  end

  # Local Authority

  factory :page_local_authority, parent: :page_user_type, traits: %i[with_exemption with_local_authority] do
    step { :local_authority }
  end

  factory :page_local_authority_postcode, parent: :page_local_authority do
    step { :local_authority_postcode }
  end

  factory :page_local_authority_address, parent: :page_local_authority_postcode do
    after(:create) do |object|
      object.create_address_search(postcode: "BS1 5AH")
    end

    step { :local_authority_address }
  end

  # Ltd Company

  factory :page_limited_company_number, parent: :page_user_type, traits: %i[with_exemption with_limited_company] do
    step { :limited_company_number }
  end

  factory :page_limited_company_name, parent: :page_limited_company_number do
    step { :limited_company_name }
  end

  factory :page_limited_company_postcode, parent: :page_limited_company_name do
    step { :limited_company_postcode }
  end

  factory :page_limited_company_address, parent: :page_limited_company_postcode do
    after(:create) do |object|
      object.create_address_search(postcode: "BS1 5AH")
    end

    step { :limited_company_address }
  end

  # LLP

  factory :page_limited_liability_partnership,
          parent: :page_user_type,
          traits: %i[with_exemption with_limited_liability_partnership] do
    step { :limited_liability_partnership_number }
  end

  factory :page_limited_liability_partnership_name, parent: :page_limited_liability_partnership do
    step { :limited_liability_partnership_name }
  end

  factory :page_limited_liability_partnership_address, parent: :page_limited_liability_partnership_name do
    step { :limited_liability_partnership_address }
  end

  # END PATHS

  factory :page_correspondence_contact, parent: :page_local_authority_address, traits: [:with_primary_address] do
    trait :with_contact do
      after(:create) do |object|
        object.correspondence_contact = create(:flood_risk_engine_contact)
        object.save!
      end
    end
    step { :correspondence_contact_name }
  end

  factory :page_correspondence_contact_name, parent: :page_correspondence_contact, traits: [:with_contact]

  factory :page_correspondence_contact_email, parent: :page_correspondence_contact_name do
    after(:create) do |object|
      object.correspondence_contact.update_attribute(:email_address, Faker::Internet.email)
    end

    step { :correspondence_contact_email }
  end

  factory :page_declaration, parent: :page_correspondence_contact_email do
    step { :declaration }
  end

  factory :page_confirmation, parent: :page_declaration do
    step { :confirmation }
  end
end
