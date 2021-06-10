require_dependency "has_secure_token"

module FloodRiskEngine
  class Address < ApplicationRecord

    has_secure_token

    belongs_to :addressable, polymorphic: true
    has_one :location, as: :locatable, dependent: :restrict_with_exception

    # Covers the RCDP Types
    #
    enum address_type: {
      primary: 0,
      secondary: 1,
      site: 2,
      contact: 3,
      billing: 4,
      principal_office: 5,
      principal_business: 6,
      registered_office: 7,
      partner: 8
    }

    def to_param
      token
    end

    def parts
      address_methods.collect { |m| send(m) }.reject(&:blank?)
    end

    def address_methods
      %i[premises street_address locality city postcode]
    end
  end
end
