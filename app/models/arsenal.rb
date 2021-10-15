# frozen_string_literal: true

class Arsenal < ApplicationRecord
  belongs_to :employee, optional: true
  belongs_to :status

  def in_mission?
    employee_id.present?
  end
end
