# frozen_string_literal: true

class Arsenal < ApplicationRecord
  validates :kind,
            uniqueness: true,
            if: :munition?

  validates :quantity,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  belongs_to :employee, optional: true
  belongs_to :status, optional: true

  scope :statuses, -> { Status.where(name: 'ativo').or(Status.where(name: 'desativado')) }
  scope :situations, -> { Status.where(name: 'irregular').or(Status.where(name: 'regular')) }

  def in_mission?
    employee_id.present?
  end

  private

  def munition?
    type == Munition.to_s || instance_of?(Munition)
  end
end
