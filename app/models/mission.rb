class Mission < ApplicationRecord
  belongs_to :team
  belongs_to :escort_service
  belongs_to :status
end
