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

  ACTIVE_STATUS = 'ativo'.freeze
  DEFAULT_PASSWORD = 'inicial1234'.freeze

  private_constant :ACTIVE_STATUS

  def escorts
    (
      [EscortScheduling.where(customer: self),
       EscortService.where(customer: self)]
    ).flatten
     .sort { |a,b| a.job_day <=> b.job_day }
  end

  def active?
    status.name == ACTIVE_STATUS
  end
end
