# frozen_string_literal: true

class EscortService < Escort
  validates :reason, presence: true, if: :refused_service?

  validate :check_allowed_internal_status

  ALLOWED_STATUSES = %w(confirmado recusado).freeze
  REFUSE_STATUS = 'recusado'.freeze

  private_constant :ALLOWED_STATUSES, :REFUSE_STATUS

  def refused_service?
    self.status.name == REFUSE_STATUS
  end

  def check_allowed_internal_status
    error_message = I18n.t('messages.errors.invalid_status')

    errors.add(:status, error_message) if ALLOWED_STATUSES.exclude?(self.status.name)
  end
end
