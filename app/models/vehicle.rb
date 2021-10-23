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

  has_many :item_movimentations
  belongs_to :team, optional: true
  belongs_to :status

  scope :available, -> { where(team: nil) }
  scope :statuses, -> { Status.where(name: 'ativo').or(Status.where(name: 'desativado')) }
end
