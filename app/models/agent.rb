# frozen_string_literal: true

class Agent < Employee
  validates :cvn_number,
            format: { with: Regex.cvn_number,
                      message: I18n.t('messages.errors.invalid_format') }

  # validate :check_cvn_validation_date

  has_many :arsenals
  has_many :tackles
  belongs_to :team, optional: true

  before_create :clear_password

  # def check_cvn_validation_date
  # return unless cvn_validation_date

  # TODO: VISUALIZAR AGENT QUE ESTÃO COM A CVN VENCIDA
  #
  # EX: José Bonfim Oliveira Santana,14/10/2019,Bonfim,11077/2016,13/10/2021,29.848.107-8,249.923.738-44
  # Johnny Silva do Nascimento,15/09/2021,Johnny,1128454/2016,29/09/2021,42.421.935-9,342.338.288-03

  # errors.add(:admission_date, message: I18n.t('messages.errors.invalid_date')) if DateTime.now > cvn_validation_date
  # end

  def clear_password
    self.password = nil
  end
end
