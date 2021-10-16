# frozen_string_literal: true

class Arsenal < ApplicationRecord
  belongs_to :employee, optional: true
  belongs_to :status

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
