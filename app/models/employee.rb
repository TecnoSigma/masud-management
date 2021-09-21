# frozen_string_literal: true

class Employee < ApplicationRecord
  validates :name,
            :email,
            :password,
            :admission_date,
            :rg,
            :cpf,
            presence: true

  belongs_to :status
  has_and_belongs_to_many :profiles

  ACTIVE_STATUS = 'ativo'

  private_constant :ACTIVE_STATUS

  def active?
    status.name == ACTIVE_STATUS
  end
end
