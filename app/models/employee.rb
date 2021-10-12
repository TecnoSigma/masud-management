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

  validates :cpf,
            format: { with: Regex.cpf,
                      message: I18n.t('messages.errors.invalid_format') }

  validate :check_admission_date,
           :check_resignation_date

  belongs_to :status
  has_one :service_token

  before_create :generate_password, unless: :profile_with_access_permission?

  ACTIVE_STATUS = 'ativo'
  MASTER_PROFILE = 'Administrator'
  PER_PAGE_IN_EMPLOYEE_DASHBOARD = 20
  PROFILES = { administrator: 'Administrador',
               agent: 'Agente',
               approver: 'Aprovador',
               lecturer: 'Conferente',
               operator: 'Operador' }

  private_constant :ACTIVE_STATUS

  def self.admin?(token)
    employee = ServiceToken.find_by_token(token).employee

    employee.instance_of?(Administrator)
  end

  def self.statuses
    Status.where(name: 'ativo')
      .or(Status.where(name: 'desligado'))
      .or(Status.where(name: 'suspenso'))
  end

  def generate_password
    self.password = Passgen.generate(length: 15)
  end

  def active?
    status.name == ACTIVE_STATUS
  end

  def profile_with_access_permission?
    instance_of?(Agent)
  end

  def check_admission_date
    return unless admission_date

    if admission_date > DateTime.now
      errors.add(:admission_date, message: I18n.t('messages.errors.invalid_date'))
    end
  end

  def check_resignation_date
    return unless resignation_date

    if  admission_date > resignation_date
      errors.add(:resignation_date, message: I18n.t('messages.errors.invalid_date'))
    end
  end
end
