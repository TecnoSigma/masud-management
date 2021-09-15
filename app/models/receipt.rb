class Receipt < ApplicationRecord
  SERIAL = 'A-1'.freeze
  LEADING_ZEROS = 5.freeze

  validates :serial,
            :credits,
            :debits,
            :period,
            presence: { message: Messages.errors[:required_field] }

  belongs_to :seller

  def place
    "#{I18n.t('dashboards.sellers.finance.receipts.receipt.default_location')} " \
    "#{self.created_at.strftime("%d")} de " \
    "#{I18n.t('months.'+self.created_at.strftime("%B/%Y").split('/').first.downcase)} de " \
    "#{self.created_at.year}."
  end

  def amount_receivable
    credit_subtotal - debit_subtotal
  end

  def credit_subtotal
    self.credits['services']
  end

  def debit_subtotal
    self.debits['inss'] + self.debits['irrf']
  end

  def self.generate!(seller:, date:, receipt: Receipt.new)
    receipt.credits = credits(date)
    receipt.debits  = debits(date)
    receipt.period  = period(date)
    receipt.seller  = seller

    receipt.valid? ? receipt.save! : false
  rescue => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    false
  end

  def self.inss(date)
    Tributes::Inss.employee(credits(date)[:services])
  end

  def self.irrf(date)
    Tributes::Irrf.employee(credits(date)[:services])
  end

  def self.debits(date)
    { inss: inss(date), irrf: irrf(date) }
  end

  def self.credits(date)
    period = monthly_period(date)

    { services: Order.monthly_approved(period[:month_start], period[:month_final]).sum(:price) }
  end

  def self.period(date)
    period = date.prev_month.strftime("%B/%Y")

    "#{I18n.t('months.'+period.split('/').first.downcase)}/#{period.split('/').last}"
  end

  def self.monthly_period(date)
    previous_month = date.prev_month

    { month_start: previous_month.beginning_of_month,
      month_final: previous_month.end_of_month }
  end

  private_class_method :inss,
                       :irrf,
                       :debits,
                       :credits,
                       :period,
                       :monthly_period
end
