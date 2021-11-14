# frozen_string_literal: true

class EscortService < Escort
  validates :reason, presence: true, if: :refused_service?

  validate :check_allowed_internal_status

  has_one :mission

  ALLOWED_STATUSES = %w[confirmado recusado finalizada].freeze
  REFUSE_STATUS = 'recusado'

  private_constant :ALLOWED_STATUSES, :REFUSE_STATUS

  def refused_service?
    status.name == REFUSE_STATUS
  end

  def check_allowed_internal_status
    error_message = I18n.t('messages.errors.invalid_status')

    errors.add(:status, error_message) if ALLOWED_STATUSES.exclude?(status.name)
  end
end
