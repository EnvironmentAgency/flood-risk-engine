require_dependency "flood_risk_engine/application_controller"

module FloodRiskEngine
  class ErrorsController < ApplicationController

    def show
      render(
        template: file_for(template),
        locals: { message: exception.try(:message), enrollment: enrollment }
      )
    end

    protected

    def error_code
      @error_code ||= params[:id]
    end

    def template_exists(name)
      File.exist? template_path(name)
    end

    def template_path(name)
      File.expand_path(
        "app/views/#{file_for(name)}.html.erb",
        FloodRiskEngine::Engine.root
      )
    end

    def template
      @template ||= template_exists(error_code) ? error_code : "generic"
    end

    def file_for(name)
      "flood_risk_engine/errors/error_#{name}"
    end

    def exception
      ENV["action_dispatch.exception"]
    end

    def enrollment
      return unless journey_token
      Enrollment.find_by(token: journey_token)
    end

    def journey_token
      @journey_token ||= journey_tokens.last
    end

  end
end
