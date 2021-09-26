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

  ACTIVE_STATUS = 'ativo'.freeze
  MASTER_PROFILE = 'Administrator'.freeze

  private_constant :ACTIVE_STATUS

  def active?
    status.name == ACTIVE_STATUS
  end

  def profile_with_access_permission?
    self.class == Agent
  end
end
