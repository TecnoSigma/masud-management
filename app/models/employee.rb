# frozen_string_literal: true

class Employee < ApplicationRecord
  validates :name,
            :admission_date,
            :rg,
            :cpf,
            presence: true

  validates :email,
            :password,
            presence: true, unless: :profile_with_access_permission?

  belongs_to :status
  has_one :service_token

  ACTIVE_STATUS = 'ativo'
  MASTER_PROFILE = 'Administrator'
  PER_PAGE_IN_EMPLOYEE_DASHBOARD = 20

  private_constant :ACTIVE_STATUS

  def self.admin?(token)
    employee = ServiceToken.find_by_token(token).employee

    employee.instance_of?(Administrator)
  end

  def active?
    status.name == ACTIVE_STATUS
  end

  def profile_with_access_permission?
    instance_of?(Agent)
  end
end
