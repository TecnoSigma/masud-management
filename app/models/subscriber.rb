class Subscriber < ApplicationRecord
  COMPANY = 'PJ'
  
  MINIMUM_QUANTITY_TO_USER = 6
  MAXIMUM_QUANTITY_TO_USER = 12
  MINIMUM_QUANTITY_TO_PASSWORD = 10
  MAXIMUM_QUANTITY_TO_PASSWORD = 20
  
  DEFAULT_COUNTRY = 'BRA'
  PERSIST_CREDIT_CARD = true

  ALLOWED_INFORMATION_LIST = ['Nome do Responsável',
                              'CPF do Responsável',
                              'CEP',
                              'Logradouro',
                              'Número',
                              'Complemento',
                              'Bairro',
                              'Cidade',
                              'Estado',
                              'Telefone',
                              'Celular']

  has_one :kit
  has_one :camera, through: :kit
  has_one :router, through: :kit
  has_one :chip, through: :kit
  has_many :vehicles
  belongs_to :plan
  has_many :angels
  has_many :tickets
  has_many :subscriptions
  has_many :drivers, through: :vehicles

  validates :code,
            :name,
            :document,
            :kind,
            :address,
            :number,
            :district,
            :city,
            :state,
            :postal_code,
            :ip,
            :telephone,
            :cellphone,
            :user,
            :password,
            :status,
            presence: { message: Messages.errors[:required_field] }

  validates :user,
            length: { in: MINIMUM_QUANTITY_TO_USER..MAXIMUM_QUANTITY_TO_USER,
                      message: Messages.errors[:invalid_characater_quantity] }

  validates :password,
            length: { in: MINIMUM_QUANTITY_TO_PASSWORD..MAXIMUM_QUANTITY_TO_PASSWORD,
                      message: Messages.errors[:invalid_characater_quantity] }

  validates :responsible_name,
            :responsible_cpf, if: :company?,
            presence: { message: Messages.errors[:required_field] }

  validates :kind,
            format: { with: Regex.kind, message: Messages.errors[:invalid_format] }

  validates :document,
            format: { with: Regex.document,
                      message: Messages.errors[:invalid_format] }

  validates :responsible_cpf,
            format: { with: Regex.cpf,
                      message: Messages.errors[:invalid_format] },
            if: :company?

  validates :email,
            format: { with: Regex.email,
                      message: Messages.errors[:invalid_format] } 

  validates :postal_code,
            format: { with: Regex.postal_code,
                      message: Messages.errors[:invalid_format] }

  validates :user,
            format: { with: Regex.user,
                      message: Messages.errors[:invalid_format] }

  validates :telephone,
            format: { with: Regex.telephone,
                      message: Messages.errors[:invalid_format] }

  validates :cellphone,
            format: { with: Regex.cellphone,
                      message: Messages.errors[:invalid_format] }
  
  validates :user,
            uniqueness: { message: Messages.errors[:already_user] }

  validates :document,
            uniqueness: { message: Messages.errors[:already_document] }

  validate :status_initial?

  scope :active, -> { where(status: Status::STATUSES[:activated], deleted_at: nil) }  

  def hidden_email
    splitted_email = self.email.split('@')
    first_char = splitted_email.first[0,1]
    suffix = splitted_email.last

    first_char + '******@' + suffix
  end

  def active?
    self.status == Status::STATUSES[:activated] && self.deleted_at.nil?
  end

  def company?
    self.kind == COMPANY
  end

  def status_initial?
    return if self.persisted?

    unless self.status == Status::STATUSES[:pendent]
      errors.add(:status, Messages.errors[:invalid_status])
    end
  end

  def have_vehicle_photos?
    self.vehicles.each do |vehicle|
      return false unless vehicle.photos.any?
    end

    true
  end

  class << self
    def code(document)
      "subscriber-#{document.remove('.', '/', '-')}"
    end

    def email(email)
      email
    end

    def fullname(responsible_name)
      responsible_name
    end

    def cpf(responsible_cpf)
      responsible_cpf.remove('.', '-')
    end

    def phone_area_code(telephone)
      telephone.split(')').first[1..-1]
    end

    def phone_number(telephone)
      telephone.split(')').last.remove(' ')
    end

    def birthdate_day(date)
      date.day
    end

    def birthdate_month(date)
      date.month
    end

    def birthdate_year(date)
      date.year
    end

    def street(street)
      street
    end

    def number(number)
      number
    end

    def complement(complement)
      complement
    end

    def district(district)
      district
    end

    def city(city)
      city
    end

    def state(state)
      States.federative_unit(state)
    end

    def postal_code(postal_code)
      postal_code.remove('-')
    end

    def holder_name(holder_name)
      holder_name.upcase
    end

    def credit_card_number(number)
      number
    end

    def expiration_month(expiration_month)
      expiration_month
    end

    def expiration_year(expiration_year)
      expiration_year[2..-1]
    end
  end
end

