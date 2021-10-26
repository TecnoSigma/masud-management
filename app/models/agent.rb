# frozen_string_literal: true

class Agent < Employee
  validates :cvn_number,
            format: { with: Regex.cvn_number,
                      message: I18n.t('messages.errors.invalid_format') }

  has_many :arsenals
  has_many :tackles
  belongs_to :team, optional: true

  before_create :clear_password

  scope :available, -> { all }

  def expired_cvn?
    cvn_validation_date < Date.today
  end

  def clear_password
    self.password = nil
  end
end
