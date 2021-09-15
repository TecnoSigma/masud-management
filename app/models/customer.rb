# frozen_string_literal: true

class Customer < ApplicationRecord
  validates :email,
            :password,
            presence: true

  belongs_to :status
  has_many :escorts

  ACTIVE_STATUS = 'ativo'

  private_constant :ACTIVE_STATUS

  def active?
    status.name == ACTIVE_STATUS
  end
end
