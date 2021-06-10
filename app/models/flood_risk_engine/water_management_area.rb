module FloodRiskEngine
  class WaterManagementArea < ApplicationRecord
    has_many :locations, dependent: :restrict_with_exception

    validates :code, presence: true, uniqueness: true
    validates :long_name, presence: true

    def self.outside_england_area
      find_or_create_by(code: "outside_england") do |area|
        area.long_name = area.short_name = area.area_name = "Outside England"
        area.area_id = nil
      end
    end
  end
end
