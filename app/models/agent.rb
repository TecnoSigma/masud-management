# frozen_string_literal: true

class Agent < Employee
  validates :codename,
            :cvn_number,
            :cvn_validation_date,
            presence: true

  has_many :arsenals
  has_many :clothes
  has_many :tackles
  belongs_to :team, optional: true
end
