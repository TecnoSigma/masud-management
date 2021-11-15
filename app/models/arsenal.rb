# frozen_string_literal: true

class Arsenal < ApplicationRecord
  has_many :item_movimentations
  belongs_to :employee, optional: true
  belongs_to :status, optional: true

  scope :statuses, -> { Status.where(name: 'ativo').or(Status.where(name: 'desativado')) }
  scope :situations, -> { Status.where(name: 'irregular').or(Status.where(name: 'regular')) }

  def in_mission?
    employee_id.present?
  end
end
