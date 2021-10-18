# frozen_string_literal: true

class Order < ApplicationRecord
  validates :job_day,
            :job_horary,
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

  PER_PAGE_IN_CUSTOMER_DASHBOARD = 20
  PER_PAGE_IN_EMPLOYEE_DASHBOARD = 20
  CANCELLATION_DEADLINE = 3.0

  private_constant :CANCELLATION_DEADLINE

  scope :filtered_escorts_by, lambda { |status|
    where(type: 'EscortScheduling')
      .or(Order.where(type: 'EscortService'))
      .select { |escort| escort.status.name == ALLOWED_STATUSES[status.to_sym] }
  }

  def self.children
    %w[EscortScheduling EscortService]
  end

  def create_order_number
    self.order_number = Time.zone.now.strftime('%Y%m%d%H%M%S')
  end

  def deletable?
    difference = TimeDifference
                 .between(created_at, Time.zone.now)
                 .in_hours

    CANCELLATION_DEADLINE >= difference
  end

  def check_job_day
    return unless job_day

    error_message = I18n.t('messages.errors.incorrect_job_day')

    errors.add(:job_day, error_message) if job_day.past?
  end

  def check_allowed_status
    error_message = I18n.t('messages.errors.invalid_status')

    errors.add(:status, error_message) if ALLOWED_STATUSES.values.exclude?(status.name)
  end

  def scheduled?
    status.name == ALLOWED_STATUSES[:scheduled]
  end

  def confirmed?
    status.name == ALLOWED_STATUSES[:confirmed]
  end

  def refused?
    status.name == ALLOWED_STATUSES[:refused]
  end

  def escort?
    type == 'EscortScheduling' || type == 'EscortService'
  end
end
