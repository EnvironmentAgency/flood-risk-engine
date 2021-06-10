module FloodRiskEngine
  class Partner < ApplicationRecord
    belongs_to :organisation
    belongs_to :contact

    delegate :full_name, :address, to: :contact

    after_save do
      organisation.try(:update_searchable_content)
    end
  end
end
