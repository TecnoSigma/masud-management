class Subscription < ApplicationRecord
  NEW_SUBSCRIBER = false
  CREDIT_CARD = 'CREDIT_CARD'

  belongs_to :subscriber
  has_one :order

  validates :code,
            :status,
            presence: { message: Messages.errors[:required_field] }

  scope :pendents, -> { where(status: Status::STATUSES[:pendent]) }
  scope :activated, -> { where(status: Status::STATUSES[:activated]) }
  scope :deactivated, -> { where(status: Status::STATUSES[:deactivated]) }

  def self.code
    "subscription-#{SecureRandom.uuid}"
  end

  def self.payment_method(payment_method)
    return CREDIT_CARD if payment_method == 'Cartão de Crédito'
  end
end
