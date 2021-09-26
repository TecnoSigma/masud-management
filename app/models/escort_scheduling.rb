# frozen_string_literal: true

class EscortScheduling < Escort
  validate :check_allowed_internal_status

  ALLOWED_STATUS = 'agendado'.freeze

  private_constant :ALLOWED_STATUS

  def check_allowed_internal_status
    error_message = I18n.t('messages.errors.invalid_status')

    errors.add(:status, error_message) unless ALLOWED_STATUS == self.status.name
  end
end
