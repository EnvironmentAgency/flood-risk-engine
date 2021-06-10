# frozen_string_literal: true

require "defra_ruby/alert"

# Class for setting configuration options in this engine. See e.g.
# http://stackoverflow.com/questions/24104246/how-to-use-activesupportconfigurable-with-rails-engine
#
# To override default config values, for example in an initaliser, use e.g.:
#
#   FloodRiskEngine.configure do |config|
#    config.exemptions_expire_after_duration = 3.years - 1.day
#   end
#
# To access configuration settings use e.g.
#   FloodRiskEngine.config.exemptions_expire_after_duration
#
module FloodRiskEngine
  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield config
  end

  def self.start_airbrake
    DefraRuby::Alert.start
  end

  class Configuration
    include ActiveSupport::Configurable

    config_accessor(:redirection_url_postcode_lookup)
    config_accessor(:layout) { "application" }
    config_accessor(:minumum_dredging_length_in_metres) { 1 }
    config_accessor(:maximum_dredging_length_in_metres) { 1500 }
    config_accessor(:maximum_company_name_length) { 170 }
    config_accessor(:maximum_individual_name_length) { 170 }
    config_accessor(:maximum_llp_name_length) { 170 }
    config_accessor(:require_journey_completed_in_same_browser) { true }
    config_accessor(:git_repository_url) # Optionally used in pages/version
    config_accessor(:application_name) # Optionally used in pages/version

    config_accessor(:govuk_guidance_url) do
      "https://www.gov.uk/government/publications/"\
      "environmental-permitting-regulations-exempt-flood-risk-activities"
    end

    def initialize
      configure_airbrake_rails_properties
    end

    def airbrake_enabled=(value)
      DefraRuby::Alert.configure do |configuration|
        configuration.enabled = change_string_to_boolean_for(value)
      end
    end

    def airbrake_host=(value)
      DefraRuby::Alert.configure do |configuration|
        configuration.host = value
      end
    end

    def airbrake_project_key=(value)
      DefraRuby::Alert.configure do |configuration|
        configuration.project_key = value
      end
    end

    def airbrake_blocklist=(value)
      DefraRuby::Alert.configure do |configuration|
        configuration.blocklist = value
      end
    end

    # Last Email caching and retrieval functionality
    def use_last_email_cache=(value)
      DefraRubyEmail.configure do |configuration|
        configuration.enable = change_string_to_boolean_for(value)
      end
    end

    private

    # If the setting's value is "true", then set to a boolean true. Otherwise, set it to false.
    def change_string_to_boolean_for(setting)
      setting = setting == "true" if setting.is_a?(String)
      setting
    end

    def configure_airbrake_rails_properties
      DefraRuby::Alert.configure do |configuration|
        configuration.root_directory = Rails.root
        configuration.logger = Rails.logger
        configuration.environment = Rails.env
      end
    end
  end
end
