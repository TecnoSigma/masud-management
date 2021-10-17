# frozen_string_literal: true

class Vehicle < ApplicationRecord
  validates :name,
            :license_plate,
            :color,
            presence: true

  belongs_to :status

  def self.statuses
    Status.where(name: 'ativo')
          .or(Status.where(name: 'desativado'))
  end
end
