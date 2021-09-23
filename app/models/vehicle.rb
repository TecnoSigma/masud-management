# frozen_string_literal: true

class Vehicle < ApplicationRecord
  validates :name,
            :license_plate,
            :color,
            presence: true

  belongs_to :status
end
