# frozen_string_literal: true

class Customer < ApplicationRecord
  validates :company,
            :cnpj,
            :email,
            presence: true

  validates :cnpj,
            format: { with: Regex.cnpj,
                      message: I18n.t('messages.errors.invalid_format') }

  validates :telephone,
            format: { with: Regex.telephone,
                      message: I18n.t('messages.errors.invalid_format') }

  belongs_to :status
  has_many :orders
  has_one :service_token

  before_create :generate_password

  ACTIVE_STATUS = 'ativo'
  DEFAULT_PASSWORD = 'inicial1234'
  HIDDEN_STATUS = 'cancelada pelo cliente'
  PER_PAGE_IN_EMPLOYEE_DASHBOARD = 20

  private_constant :ACTIVE_STATUS, :HIDDEN_STATUS

  def self.statuses
    Status.where(name: 'ativo').or(Status.where(name: 'desativado'))
  end

  def generate_password
    self.password = Passgen.generate(length: 15)
  end

  def escorts
    [EscortScheduling.where(customer: self),
     EscortService.where(customer: self)]
      .flatten
      .reject { |escort| escort.status.name == HIDDEN_STATUS }
      .reject { |escort| escort.status == Status.find_by_name('finalizada') }
      .sort { |a, b| a.job_day <=> b.job_day }
  end

  def finished_escorts
    escorts.map do |escort|
      escort if escort.type == 'EscortService' &&
                escort.mission.present? &&
                escort.mission.finished_at.present?
    end
           .compact
  end

  def active?
    status.name == ACTIVE_STATUS
  end
end
