# frozen_string_literal: true

class Customer < ApplicationRecord
  validates :company,
            :cnpj,
            :email,
            :password,
            presence: true

  belongs_to :status
  has_many :services
  has_one :service_token

  ACTIVE_STATUS = 'ativo'.freeze
  DEFAULT_PASSWORD = 'inicial1234'.freeze

  private_constant :ACTIVE_STATUS

  def escorts
    services.order(:job_day).select do |service|
      service.type == 'EscortScheduling' || service.type == 'EscortMission'
    end
  end

  def active?
    status.name == ACTIVE_STATUS
  end
end
