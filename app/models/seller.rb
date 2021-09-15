class Seller < ApplicationRecord
  PASSWORD_LENGTH = 10.freeze

  validates :name,
            :code,
            :core_register,
            :expedition_date,
            :expiration_date,
            :document,
            :cellphone,
            :email,
            :linkedin,
            :address,
            :number,
            :district,
            :city,
            :state,
            :postal_code,
            :status,
            :password,
            presence: { message: Messages.errors[:required_field] }

  validates :core_register,
            uniqueness: { message: Messages.errors[:already_core_register] }

  validates :document,
            uniqueness: { message: Messages.errors[:already_document] }

  validates :document,
            format: { with: Regex.cpf, message: Messages.errors[:invalid_format] }

  validates :core_register,
            format: { with: Regex.core_register, message: Messages.errors[:invalid_format] }

  validates :email,
            format: { with: Regex.email, message: Messages.errors[:invalid_format] }

  validates :cellphone,
            format: { with: Regex.cellphone, message: Messages.errors[:invalid_format] }

  validates :postal_code,
            format: { with: Regex.postal_code, message: Messages.errors[:invalid_format] }

  validates :linkedin,
            format: { with: Regex.linkedin_url, message: Messages.errors[:invalid_format] }

  has_many :orders
  has_many :receipts
  has_one :account
  has_one :bank, through: :account

  scope :activated, -> { where(status: Status::STATUSES[:activated]) }

  def self.generate_code(document)
    "seller-#{document.remove('.', '/', '-')}"
  end

  def self.generate_password(length = PASSWORD_LENGTH)
    chars = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
    chars.sort_by { rand }.join[0...length]
  end

  def location
    complement = self.complement ? "- #{self.complement} -" : '-'

    "#{self.address}, #{self.number} #{complement} #{self.district}"
  end

  def active?
    self.status == Status::STATUSES[:activated] && self.deleted_at.nil?
  end

  def hidden_email
    splitted_email = self.email.split('@')
    first_char = splitted_email.first[0,1]
    suffix = splitted_email.last

    first_char + '******@' + suffix
  end
end
