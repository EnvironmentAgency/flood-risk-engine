module FloodRiskEngine
  class Comment < ApplicationRecord
    belongs_to :commentable, polymorphic: true
    belongs_to(:user) if defined?(User)
  end
end
