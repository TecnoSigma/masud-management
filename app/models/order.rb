class Order < ApplicationRecord
  PAGINATE = 20.freeze

  validates :price,
            :status,
            presence: { message: Messages.errors[:required_field] }

  validates :price, numericality: { only_integer: false, message: Messages.errors[:invalid_format] }

  validate :check_approval_date

  belongs_to :subscription
  belongs_to :seller

  before_create :generate_code

  scope :monthly_approved, ->(start_date, final_date) { where(approved_at: start_date..final_date) }
  scope :by_sale_date, -> { order(created_at: :desc) }
  scope :totals_by_status, ->(status) { where(status: status).sum(:price) }

  private

    def check_approval_date
      if self.status == Status::ORDER_STATUSES[:approved] && self.approved_at.nil?
        errors.add(:approved_at, Messages.errors[:required_field])
      end
    end

    def generate_code
      self.code = DateTime.now.strftime("%Y%m%d%H%M%S%L")
    end
end
