module FloodRiskEngine
  class Exemption < ApplicationRecord
    default_scope { order(:code_number) }

    LONG_DREDGING_CODES = %w[FRA23].freeze

    has_many :enrollment_exemptions,
             dependent: :restrict_with_exception
    has_many :enrollments,
             through: :enrollment_exemptions,
             dependent: :restrict_with_exception

    enum category: {
    }

    before_save :update_code_number

    # An exemption's friendly name, used for example when listing exemptions in an email.
    def to_s
      "#{code}: #{summary}"
    end

    def long_dredging?
      LONG_DREDGING_CODES.include? code
    end

    private

    def update_code_number
      self.code_number = code.gsub(/\D/, "").to_i
    end
  end
end
