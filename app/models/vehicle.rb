# frozen_string_literal: true

class Vehicle < ApplicationRecord
  validates :name,
            :license_plate,
            :color,
            presence: true

  validates :license_plate,
            uniqueness: true

  validates :license_plate,
            format: { with: Regex.license_plate,
                      message: I18n.t('messages.errors.invalid_format') }

  belongs_to :status

  def self.statuses
    Status.where(name: 'ativo')
          .or(Status.where(name: 'desativado'))
  end
end
