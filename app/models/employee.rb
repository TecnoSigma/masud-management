# frozen_string_literal: true

class Employee < ApplicationRecord
  validates :name,
            :admission_date,
            :rg,
            :cpf,
            presence: true

  validates :codename,
            :cvn_number,
            :cvn_validation_date,
            presence: true,
            if: :agent?

  validates :email,
            :password,
            presence: true,
            unless: :profile_with_access_permission?

  validates :cpf,
            format: { with: Regex.cpf,
                      message: I18n.t('messages.errors.invalid_format') }

  validate :check_admission_date,
           :check_resignation_date

  belongs_to :status
  has_one :service_token
  has_many :arsenals
  has_many :tackles
  has_many :bullets

  ACTIVE_STATUS = 'ativo'
  MASTER_PROFILE = 'Administrator'
  PER_PAGE_IN_EMPLOYEE_DASHBOARD = 20

  ALL_PROFILES = { administrator: 'Administrador',
                   agent: 'Agente',
                   approver: 'Aprovador',
                   lecturer: 'Conferente',
                   operator: 'Operador' }.freeze

  PROFILES = { administrator: 'Administrador',
               operator: 'Operador' }.freeze

  private_constant :ACTIVE_STATUS

  def self.profiles
    Rails.env.production? ? PROFILES : ALL_PROFILES
  end

  def self.admin?(token)
    employee = ServiceToken.find_by_token(token).employee

    employee.instance_of?(Administrator)
  end

  def self.statuses
    Status.where(name: 'ativo')
          .or(Status.where(name: 'desligado'))
          .or(Status.where(name: 'suspenso'))
  end

  def self.generate_password
    Passgen.generate(length: 15)
  end

  def active?
    status.name == ACTIVE_STATUS
  end

  def profile_with_access_permission?
    agent?
  end

  def agent?
    instance_of?(Agent)
  end

  def check_admission_date
    return unless admission_date

    errors.add(:admission_date, message: I18n.t('messages.errors.invalid_date')) if admission_date > DateTime.now
  end

  def check_resignation_date
    return unless resignation_date

    errors.add(:resignation_date, message: I18n.t('messages.errors.invalid_date')) if admission_date > resignation_date
  end
end
