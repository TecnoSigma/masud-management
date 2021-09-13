class Customer < ApplicationRecord
  validates :email,
            :password,
            presence: true

  belongs_to :status
  has_many :escorts

  ACTIVE_STATUS = 'ativo'.freeze

  private_constant :ACTIVE_STATUS

  def active?
    self.status.name == ACTIVE_STATUS
  end
end
