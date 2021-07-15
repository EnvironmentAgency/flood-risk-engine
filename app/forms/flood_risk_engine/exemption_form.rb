# frozen_string_literal: true

module FloodRiskEngine
  class ExemptionForm < ::FloodRiskEngine::BaseForm
    delegate :exemptions, to: :transient_registration

    validates :exemptions, "flood_risk_engine/exemptions": true

    attr_accessor :exemption_id

    def all_exemptions
      @all_exemptions ||=
        Exemption.all.map do |exemption|
          ExemptionPresenter.new(exemption)
        end
    end
  end
end
