# frozen_string_literal: true

class Arsenal < ApplicationRecord
  validates :kind,
            uniqueness: true

  validates :quantity,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  belongs_to :employee, optional: true
  belongs_to :status, optional: true

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
