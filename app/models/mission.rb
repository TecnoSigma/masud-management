class Mission < ApplicationRecord
  has_one :mission_history
  belongs_to :team
  belongs_to :escort_service
  belongs_to :status
end
