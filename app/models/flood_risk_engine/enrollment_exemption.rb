module FloodRiskEngine
  class EnrollmentExemption < ActiveRecord::Base
    self.table_name = "flood_risk_engine_enrollments_exemptions"

    belongs_to :enrollment, foreign_key: :enrollment_id
    belongs_to :exemption
    has_many :comments, as: :commentable

    enum status: {
      building: 0,        # FO: anywhere before the confirmation step
      pending: 1,         # FO: enrollment submitted and awaiting BO processing
      being_processed: 2, # BO: prevents another admin user from processing it
      approved: 3,        # BO: all checks pass
      rejected: 4,        # BO: because e.g. grid ref in an SSI
      expired: 5,         # BO: FRA23/24 only - expiry date has passed
      withdrawn: 6        # BO: used to hide anything created in error
    }

    def self.include_long_dredging?
      includes(:exemption).where(flood_risk_engine_exemptions: { code: Exemption::LONG_DREDGING_CODES }).any?
    end

    def latest_decision
      comments.order(:created_at).pluck(:created_at, :user_id).last
    end

    def decision_at_and_user
      return [nil, nil] if comments.empty?
      latest = latest_decision
      [latest.first, User.find(latest.last).try(:email)]
    end

    def decision_at
      return if comments.empty?
      latest_decision.first
    end

    def decision_user_id
      return if comments.empty?
      latest_decision.last
    end

  end
end
