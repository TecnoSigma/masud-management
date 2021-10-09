# frozen_string_literal: true

class Customer < ApplicationRecord
  validates :company,
            :cnpj,
            :email,
            :password,
            presence: true

  belongs_to :status
  has_many :orders
  has_one :service_token

  ACTIVE_STATUS = 'ativo'
  DEFAULT_PASSWORD = 'inicial1234'
  HIDDEN_STATUS = 'cancelado pelo cliente'
  PER_PAGE_IN_EMPLOYEE_DASHBOARD = 20

  private_constant :ACTIVE_STATUS, :HIDDEN_STATUS

  def escorts
    [EscortScheduling.where(customer: self),
     EscortService.where(customer: self)]
      .flatten
      .reject { |escort| escort.status.name == HIDDEN_STATUS }
      .sort { |a, b| a.job_day <=> b.job_day }
  end

  def active?
    status.name == ACTIVE_STATUS
  end
end
