# frozen_string_literal: true

class Order < ApplicationRecord
  validates :job_day,
            :source_address,
            :source_number,
            :source_district,
            :source_city,
            :source_state,
            :destiny_address,
            :destiny_number,
            :destiny_district,
            :destiny_city,
            :destiny_state,
            presence: true

  validate :check_job_day,
           :check_allowed_status

  belongs_to :customer
  belongs_to :status

  before_create :create_order_number

  ALLOWED_STATUSES = {
    scheduled: 'agendado',
    confirmed: 'confirmado',
    refused: 'recusado',
    cancelled_by_customer: 'cancelado pelo cliente'
  }.freeze

  PER_PAGE_IN_CUSTOMER_DASHBOARD = 20.freeze
  CANCELLATION_DEADLINE = 3.0.freeze

  private_constant :ALLOWED_STATUSES, :CANCELLATION_DEADLINE

  def create_order_number
    self.order_number = Time.zone.now.strftime('%Y%m%d%H%M%S')
  end

  def deletable?
    difference = TimeDifference
      .between(self.created_at, Time.zone.now)
      .in_hours

    CANCELLATION_DEADLINE >= difference
  end

  def check_job_day
    return unless self.job_day

    error_message = I18n.t('messages.errors.incorrect_job_day')

    errors.add(:job_day, error_message) if self.job_day.past?
  end

  def check_allowed_status
    error_message = I18n.t('messages.errors.invalid_status')

    errors.add(:status, error_message) if ALLOWED_STATUSES.values.exclude?(self.status.name)
  end

  def scheduled?
    self.status.name == ALLOWED_STATUSES[:scheduled]
  end

  def confirmed?
    self.status.name == ALLOWED_STATUSES[:confirmed]
  end

  def refused?
    self.status.name == ALLOWED_STATUSES[:refused]
  end
end
