module FloodRiskEngine
  class Organisation < ApplicationRecord
    belongs_to :contact
    has_one :enrollment, dependent: :restrict_with_exception
    has_many :partners # Only needed for Partnerships
    has_one :primary_address, -> { where(address_type: Address.address_types["primary"]) },
            class_name: "FloodRiskEngine::Address",
            as: :addressable,
            dependent: :restrict_with_exception

    enum org_type: {
      local_authority: 0,
      limited_company: 1,
      limited_liability_partnership: 2,
      individual: 3,
      partnership: 4,
      other: 5,
      unknown: 6
    }

    after_save :update_searchable_content

    # This is a temporary solution to allow searching multiple partners without
    # returning duplicates in a complicated SQL query with outer joins.
    def update_searchable_content
      update_column(:searchable_content, contact_search_string)
    end

    private

    def contact_search_string
      if partnership?
        partners.map(&:full_name).join(" ")
      elsif contact.present?
        contact.full_name
      end
    end

  end
end
