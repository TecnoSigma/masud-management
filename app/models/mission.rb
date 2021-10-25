class Mission < ApplicationRecord
  belongs_to :team
  belongs_to :escort_service
  belongs_to :status
  has_and_belongs_to_many :agents
end
