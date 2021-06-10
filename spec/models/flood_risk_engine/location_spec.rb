require "rails_helper"

module FloodRiskEngine
  RSpec.describe Location, type: :model do
    it { is_expected.to belong_to(:locatable) }
    it { is_expected.to respond_to(:water_management_area) }

    context "scopes" do
      describe ".missing_area" do
        it "only returns records with a missing area" do
          missing_area_record = create(:location, water_management_area: nil)
          create(:location, water_management_area: create(:water_management_area))

          expect(described_class.missing_area).to match_array([missing_area_record])
        end
      end

      describe ".with_easting_and_northing" do
        it "only returns records with both easting and northing defined" do
          with_easting_and_northing = create(:location, easting: "123.45", northing: "123.45")

          # Bypass before save filter
          create(:location).update(easting: "123.45", northing: "")
          create(:location).update(easting: "123.45", northing: "")
          create(:location).update(easting: "", northing: "123.45")
          create(:location).update(easting: "", northing: "123.45")
          create(:location).update(easting: nil, northing: nil)

          expect(described_class.with_easting_and_northing).to match_array([with_easting_and_northing])
        end
      end

      describe ".from_site_address" do
        it "only returns records with an address of type :site" do
          from_site_address = create(:location, locatable: create(:address, :site))

          create(:location)
          create(:location, locatable: create(:address, :primary))

          expect(described_class.from_site_address).to match_array([from_site_address])
        end
      end
    end

    describe "grid reference processing" do
      let(:palace) do
        OpenStruct.new(
          postcode: "SW1A 1AA",
          grid_reference: "TQ 29090 79645",
          easting: "529090",
          northing: "179645",
          latitude: 51.501009,
          longitude: -0.1415876
        )
      end

      let(:mountain) do
        OpenStruct.new(
          postcode: "LL55 4UL",
          grid_reference: "SH 60992 54374",
          easting: "260992",
          northing: "354374",
          latitude: 53.068468,
          longitude: -4.0761369
        )
      end
      let(:location) { create(:location, grid_reference: palace.grid_reference.delete(" ")) }

      it "should tidy format of grid reference" do
        expect(location.grid_reference).to eq(palace.grid_reference)
      end

      it "should save coresponding easting and northing" do
        expect(location.easting.to_i).to eq(palace.easting.to_i)
        expect(location.northing.to_i).to eq(palace.northing.to_i)
      end

      it "should allow grid reference to be changed" do
        location.update_attribute :grid_reference, mountain.grid_reference
        expect(location.grid_reference).to eq(mountain.grid_reference)
        expect(location.easting.to_i).to eq(mountain.easting.to_i)
        expect(location.northing.to_i).to eq(mountain.northing.to_i)
      end
    end
  end
end
