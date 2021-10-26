class MissionHistory < ApplicationRecord
  validates :team,
            :agents,
            :items,
            presence: true

  belongs_to :mission
end
