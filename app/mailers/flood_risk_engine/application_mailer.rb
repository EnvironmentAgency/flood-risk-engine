module FloodRiskEngine
  class ApplicationMailer < ActionMailer::Base
    add_template_helper(EmailHelper)
    layout "flood_risk_engine/layouts/mail"
  end
end
