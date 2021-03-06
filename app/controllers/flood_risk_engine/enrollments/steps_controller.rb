# This controller is responsible for the progressive 'building' of an
# enrollment. This has a couple of advantages over using custom get
# and patch routes to target enrollments_controller#edit and #update:
# - clearer separation of concerns
# - leaves EnrollmentsController free for more conventional use
# - 'steps' map to 'views' naturally e.g. app/views/enrollments/steps
# - more RESTful e.g. enrollments/123/steps/step1
#
module FloodRiskEngine
  module Enrollments
    class StepsController < ApplicationController

      rescue_from StepError, with: :step_not_found
      rescue_from JourneyError, ActiveRecord::RecordInvalid, with: :step_not_valid

      before_action :check_step_is_valid
      before_action :back_button_cache_buster
      before_action :clear_error_params, only: [:update]

      def show
        form.validate(session[:error_params]) if params[:check_for_error]
        render form.view_path, locals: locals
      end

      def update
        success = save_form!
        if form.redirect?
          redirect_to(form.redirection_url)
        elsif success
          step_forward
          redirect_to step_url
        else
          handle_failure_and_redirect_back_to_show
        end
      end

      private

      def handle_failure_and_redirect_back_to_show
        logger.error("Form save failed : [#{form.errors.messages.inspect}")
        # error_params will be the submitted form data or an empty hash if nothing submitted.
        session[:error_params] = {
          form.params_key => params.fetch(form.params_key, {})
        }
        redirect_to step_url(check_for_error: true)
      end

      def step
        @step ||= params.fetch(:id).to_sym
      end

      def step_url(options = {})
        enrollment_step_path(enrollment, enrollment.current_step, options)
      end

      def check_step_is_valid
        check_journey_valid
        return true if step_is_current?
        return step_back if step_back_is_possible?
        raise StepError, "Requested :#{step}, is not permitted when enrollment.step is :#{enrollment.current_step}"
      end

      def check_journey_valid
        return true unless FloodRiskEngine.config.require_journey_completed_in_same_browser
        return true if journey_tokens.include?(enrollment.token)
        raise(JourneyError, "Journey not started in current browser session")
      end

      def step_back_is_possible?
        enrollment.previous_step? step
      rescue StateMachineError
        false
      end

      def step_forward
        enrollment.go_forward
        enrollment.save
      end

      def step_back
        enrollment.go_back
        enrollment.save
      end

      def step_is_current?
        step.to_s == enrollment.current_step.to_s
      end

      def save_form!
        return false unless form.validate(params)
        return false unless enrollment.save
        form.save
      end

      # Using the approach that all vars are passed explicitly to the template
      # rather than relying on exposing @vars which, lets face it, is not great.
      def locals
        {
          form: form,
          step: step
        }
      end

      # Delegate instantiation of the form object to an abstract factory
      def form
        @form ||= Steps::FormObjectFactory.form_object_for(step, enrollment)
      end

      def enrollment
        @enrollment ||= Enrollment.find_by_token!(params[:enrollment_id])
      end

      def step_not_valid(exception)
        Rails.logger.info "STEP NOT VALID: #{exception.message}"
        redirect_to error_path(:step_not_valid)
      end

      def step_not_found(exception)
        Rails.logger.info "STEP NOT FOUND: #{exception.message}"
        redirect_to step_url
      end

      def clear_error_params
        session[:error_params] = {}
      end

    end
  end
end
