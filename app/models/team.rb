# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true

  has_one :mission
  has_many :vehicles
  has_many :employees

  scope :available, -> { select { |team| team.employees.empty? } }
end
