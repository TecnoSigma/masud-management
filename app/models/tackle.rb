# frozen_string_literal: true

class Tackle < ApplicationRecord
  validates :serial_number,
            :situation,
            presence: true

  validates :serial_number,
            uniqueness: true

  has_many :item_movimentations
  belongs_to :employee, optional: true
  belongs_to :status

  ALLOWED_TYPES = { waistcoat: 'Colete', radio: 'Rádio' }.freeze

  scope :available, -> { where(employee: nil) }
  scope :statuses, -> { Status.where(name: 'ativo').or(Status.where(name: 'desativado')) }
  scope :situations, -> { Status.where(name: 'irregular').or(Status.where(name: 'regular')) }

  def in_mission?
    employee_id.present?
  end
end
