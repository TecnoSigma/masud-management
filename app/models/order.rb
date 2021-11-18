# frozen_string_literal: true

class Order < ApplicationRecord
  validates :job_day, :job_horary, :source_address, :source_number, :source_district, :source_city,
            :source_state, :destiny_address, :destiny_number, :destiny_district, :destiny_city,
            :destiny_state,
            presence: true

  validates :job_horary,
            format: { with: Regex.horary, message: I18n.t('messages.errors.invalid_format') }

  validate :check_start_day, :check_allowed_status

  belongs_to :customer
  belongs_to :status

  before_create :create_order_number

  ALLOWED_REFUSES = 2

  ALLOWED_STATUSES = {
    started: 'iniciada',
    scheduled: 'aguardando confirmação',
    blocked: 'bloqueada',
    confirmed: 'confirmada',
    refused: 'recusada',
    finished: 'finalizada',
    cancelled: 'cancelada',
    cancelled_by_customer: 'cancelada pelo cliente'
  }.freeze

  PIE_COLORS = {
    started: '#44a6c6',
    scheduled: '#ffff00',
    blocked: '#9800eb',
    confirmed: '#4528a7',
    refused: '#ff0000',
    finished: '#28a745',
    cancelled: '#636363',
    cancelled_by_customer: '#ffc107'
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

  def self.scheduled(order_type)
    select { |order| order.type == order_type && order.status.name == ALLOWED_STATUSES[:scheduled] }
      .sort do |a, b|
      current_order = DateTime.parse("#{a.job_day} #{a.job_horary}")
      next_order = DateTime.parse("#{b.job_day} #{b.job_horary}")

      current_order <=> next_order
    end
  end

  def self.chart_by_status
    { statuses: chart_by_status_data.map { |label| label[:status] },
      quantities: chart_by_status_data.map { |label| label[:quantity] },
      colors: chart_by_status_data.map { |label| label[:piece_color] } }
  end

  def create_order_number
    self.order_number = Time.zone.now.strftime('%Y%m%d%H%M%S')
  end

  def prevision
    DateTime.parse("#{job_day} #{job_horary}")
  end

  def deletable?
    difference = TimeDifference.between(prevision, Time.zone.now).in_hours

    difference >= CANCELLATION_DEADLINE
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

  private

  def check_start_day
    return unless job_day

    errors.add(:job_day, I18n.t('messages.errors.incorrect_start_day')) if prevision.past?
  end

  def check_allowed_status
    error_message = I18n.t('messages.errors.invalid_status')

    errors.add(:status, error_message) if ALLOWED_STATUSES.values.exclude?(status.name)
  end

  def self.chart_by_status_data
    Order
      .where(type: 'EscortService')
      .or(Order.where(type: 'EscortScheduling'))
      .group(:status)
      .count
      .map { |order| order }
      .map do |status|
      piece_color = PIE_COLORS[ALLOWED_STATUSES.key(status.first[:name])]

      { status: status.first[:name], quantity: status.last, piece_color: piece_color }
    end
  end

  private_class_method :chart_by_status_data
end
