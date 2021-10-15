# frozen_string_literal: true

class Tackle < ApplicationRecord
  validates :serial_number,
            :situation,
            presence: true

  validates :serial_number,
            uniqueness: true

  belongs_to :agent, optional: true
  belongs_to :status

  ALLOWED_TYPES = { waistcoat: 'Colete', radio: 'Rádio' }.freeze

  def self.statuses
    Status.where(name: 'ativo')
          .or(Status.where(name: 'desativado'))
  end

  def self.situations
    Status.where(name: 'irregular')
          .or(Status.where(name: 'regular'))
  end

  def in_mission?
    employee_id.present?
  end
end
