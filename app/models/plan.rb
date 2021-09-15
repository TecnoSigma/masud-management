class Plan < ApplicationRecord
  ENTERPRISE_PLAN_NAME = 'Enterprise'
  ALLOWED_PAYMENT_METHODS = ['Cartão de Crédito']
  DEFAULT_PAYMENT_METHOD = 'Cartão de Crédito'
  PLAN_CODES_WITH_STORAGE = ['master-angels', 'premium-angels'].freeze

  has_many :subscribers
  has_many :subscriptions, through: :subscribers
  has_many :orders, through: :subscriptions

  validates :name,
            :code,
            :price,
            :status,
            presence: { message: Messages.errors[:required_field] }
  validates :name,
            uniqueness: { message: Messages.errors[:already_plan_name] }
  validates :code,
            uniqueness: { message: Messages.errors[:already_plan_code] } 

  validate :allowed_name?
  validate :initial_status?
  validate :valid_price?

  def initial_status?
    return if self.persisted?

    unless self.status == Status::STATUSES[:activated]
      errors.add(:status, Messages.errors[:invalid_status])
    end
  end

  def allowed_name?
    if PLAN_CONFIG[:plans][:data].pluck(:name).exclude?(self.name)
      errors.add(:name, Messages.errors[:invalid_plan_name])
    end
  end

  def valid_price?
    return if self.price.nil?

    errors.add(:price, Messages.errors[:invalid_price]) unless self.price.positive?
  end
end
