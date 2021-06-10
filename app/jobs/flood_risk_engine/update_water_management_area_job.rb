module FloodRiskEngine
  class UpdateWaterManagementAreaJob < ActiveJob::Base
    def perform(location)
      raise MissingLocationArgumentError unless location

      @location = location

      Location.transaction do
        @location.water_management_area = identify_area
        @location.save!
      end
    end

    private

    def identify_area
      response = DefraRuby::Area::WaterManagementAreaService.run(@location.easting, @location.northing)

      return process_successful_response(response.areas.first) if response.successful?

      process_unsuccessful_response(response)
    end

    def process_successful_response(area)
      WaterManagementArea.find_or_create_by(code: area.code) do |water_management_area|
        water_management_area.update(
          area_id: area.area_id,
          area_name: area.area_name,
          short_name: area.short_name,
          long_name: area.long_name
        )
      end
    end

    def process_unsuccessful_response(response)
      return WaterManagementArea.outside_england_area if response.error.instance_of?(DefraRuby::Area::NoMatchError)

      # Any other error we log it and just return nil
      Airbrake.notify(response.error, easting: @location.easting, northing: @location.northing) if defined? Airbrake
      Rails.logger.error "Update water management area job failed: #{response.error}"

      nil
    end
  end
end
