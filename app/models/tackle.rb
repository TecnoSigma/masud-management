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
  RADIO_MAXIMUM_QUANTITY = 1
  WAISTCOAT_MAXIMUM_QUANTITY = 2

  scope :statuses, -> { Status.where(name: 'ativo').or(Status.where(name: 'desativado')) }
  scope :situations, -> { Status.where(name: 'irregular').or(Status.where(name: 'regular')) }

  def in_mission?
    employee_id.present?
  end

  def self.available(type)
    total = total_by_type(type).count
    allowed_quantity = const_get("#{type.upcase}_MAXIMUM_QUANTITY")

    total < allowed_quantity ? total : allowed_quantity
  end

  def self.total_by_type(type)
    where(type: type.titleize).where(employee: nil)
  end

  private_class_method :total_by_type
end
