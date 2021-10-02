# frozen_string_literal: true

class EscortScheduling < Escort
  validate :check_allowed_internal_status

  ALLOWED_STATUSES = [
    'agendado',
    'cancelado pelo cliente'
  ].freeze

  private_constant :ALLOWED_STATUSES

  def check_allowed_internal_status
    error_message = I18n.t('messages.errors.invalid_status')

    errors.add(:status, error_message) if ALLOWED_STATUSES.exclude?(status.name)
  end
end
