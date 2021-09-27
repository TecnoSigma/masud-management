# frozen_string_literal: true

class Service < ApplicationRecord
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

  ALLOWED_STATUSES = %w(agendado confirmado recusado).freeze

  private_constant :ALLOWED_STATUSES

  def check_job_day
    return unless self.job_day

    error_message = I18n.t('messages.errors.incorrect_job_day')

    errors.add(:job_day, error_message) if self.job_day.past?
  end

  def check_allowed_status
    error_message = I18n.t('messages.errors.invalid_status')

    errors.add(:status, error_message) if ALLOWED_STATUSES.exclude?(self.status.name)
  end
end
