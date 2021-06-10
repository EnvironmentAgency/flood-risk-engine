require "validates_email_format_of"

module FloodRiskEngine
  class Contact < ApplicationRecord
    has_one :organisation, dependent: :restrict_with_exception
    has_one :address, as: :addressable, dependent: :restrict_with_exception

    enum contact_type: {
      individual: 0,
      partner: 1,
      employee: 2,
      applicant: 3,
      correspondence: 4,
      operation: 5,
      establishment_or_undertaking: 6
    }

    # Derived from RCDP customer data model
    enum title: %w[
      na Mr Mrs Miss Ms Dr Rev Sir Lady Lord
      Captain Major Professor Dame Colonel
    ]

    after_save do
      organisation.try(:update_searchable_content)
    end

  end
end
