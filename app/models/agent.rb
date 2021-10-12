# frozen_string_literal: true

class Agent < Employee
  validates :codename,
            :cvn_number,
            :cvn_validation_date,
            presence: true

  validates :cvn_number,
            format: { with: Regex.cvn_number,
                      message: I18n.t('messages.errors.invalid_format') }

  validate :check_cvn_validation_date

  has_many :arsenals
  has_many :tackles
  belongs_to :team, optional: true

  before_create :clear_password

  def check_cvn_validation_date
    return unless cvn_validation_date

    if DateTime.now > cvn_validation_date
      errors.add(:admission_date, message: I18n.t('messages.errors.invalid_date'))
    end
  end

  def clear_password
    self.password = nil
  end
end
