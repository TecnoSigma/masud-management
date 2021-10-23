# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true

  has_one :vehicle
  has_many :employees
end
