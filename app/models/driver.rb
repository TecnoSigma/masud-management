class Driver < ApplicationRecord
  QR_CODES_FOLDER = 'qr_codes'

  EXCEEDED_DAYS_TO_DRIVER_LICENSE = 30.freeze

  validates :name,
            :code,
            :paid_activity,
            :license,
            :expedition_date,
            :expiration_date,
            :status,
            presence: { message: Messages.errors[:required_field] }

  validates :license, 
            format: { with: Regex.driver_license,
                      message: Messages.errors[:invalid_format] }

  validate :check_expiration_date
  validate :check_expedition_date

  has_and_belongs_to_many :angels
  has_and_belongs_to_many :vehicles
  has_many :ratings
  has_one_attached :qrcode
  has_one_attached :avatar
  has_one_attached :document

  scope :licenses, -> { map { |driver| [driver.license, driver.name] } }

  def generate_code
    "driver-#{self.license.gsub('.','')}"
  end

  def check_expedition_date
    return unless self.expedition_date

    if self.expedition_date.to_datetime > DateTime.now
      errors.add(:expedition_date, 'A data de expedição não pode ser maior que a data-corrente!')
    end
  end

  def check_expiration_date
    return unless self.expiration_date

    if (DateTime.now - self.expiration_date.to_datetime).to_i > EXCEEDED_DAYS_TO_DRIVER_LICENSE 
      errors.add(:expiration_date, "A data de expiração da CNH não pode ser maior que 30 dias")
    end
  end

  def transmission_url
    "#{ENV['APP_QRCODE_TRANSMISSION_URI']}driver-#{SecureRandom.uuid}"
  end

  def create_qrcode!
    file_name = "qr_code-#{self.code}"

    result = QrCode.create!(file_folder: QR_CODES_FOLDER,
                            file_name: file_name,
                            qrcode_value: transmission_url)

    send_qrcode_to_storage!(filepath: result)
  end

  private

    def send_qrcode_to_storage!(filepath:)
      filename = filepath.split('/').last

      self.qrcode.attach(io: File.open(filepath), filename: filename)

      true
    rescue => e
      Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")

      false
    end
end
