module FloodRiskEngine
  module Steps
    class BaseAddressSearchForm < BaseRedirectableForm
      property :postcode

      validates :postcode, presence: { message: I18n.t("flood_risk_engine.validation_errors.postcode.blank") }

      validates :postcode, 'flood_risk_engine/postcode': true, allow_blank: true

      def validate(params)
        valid = super(params)

        return false unless valid

        look_up_addresses

        check_for_errors_and_toggle_manual_entry
      end
      # rubocop:enable Metrics/MethodLength

      def manual_entry_enabled?
        @manual_entry_enabled
      end

      # Currently all OrgType journeys lead from Address to Correspondence Contact Name
      def target_step
        :correspondence_contact_name
      end

      # We are required to display a notice regarding use of OS places data in
      # postcode lookup pages. However we wish to display this below the
      # continue button, which means those pages have to take control of where
      # it is positioned. To do this we override the show_continue_button? and
      # return false, so that
      # app/views/flood_risk_engine/enrollments/steps/show.html.erb knows not
      # to take control for showing the button.
      def show_continue_button?
        false
      end

      private

      # Look up addresses based on the postcode
      def look_up_addresses
        response = AddressLookupService.run(postcode)

        Rails.logger.info "***** LOOKUP: *****"
        Rails.logger.info url
        Rails.logger.info response.successful?
        Rails.logger.info response.results
        Rails.logger.info response.error

        return true if response.successful?

        if response.error == DefraRuby::Address::NoMatchError
          handle_no_matching_addresses
          false
        else
          handle_address_service_error
          true
        end
      end

      def handle_no_matching_addresses
        # This is a Valid UK postcode but it does not currently point to any addresses.
        # If we don't save this postcode in the search, get inconsistencies when users enters a Manual
        # address and then goes back
        sync
        model.save

        errors.add :postcode, I18n.t("flood_risk_engine.validation_errors.postcode.no_addresses_found")
      end

      def handle_address_service_error
        errors.add :postcode, I18n.t("flood_risk_engine.validation_errors.postcode.service_unavailable")
      end

      # RIP-74 states when search valid but no postcodes or service type failure, include Manual Address entry link
      def check_for_errors_and_toggle_manual_entry
        if errors[:postcode].empty?
          @manual_entry_enabled = false
          true
        else
          @manual_entry_enabled = true
          false
        end
      end

      def url
        host = DefraRuby::Address.configuration.host
        client_id = DefraRuby::Address.configuration.client_id
        key = DefraRuby::Address.configuration.key

        File.join(
          host,
          "/address-service/v1/addresses/",
          "postcode?client-id=#{client_id}&key=#{key}&#{param_name}=#{postcode}"
        )
      end
    end

  end
end
