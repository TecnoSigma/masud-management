require 'rqrcode'

module QrCode
  class << self
    def create!(file_folder:, file_name:, qrcode_value:)
      image_name = "#{file_name}.png"
      qrcode = RQRCode::QRCode
                 .new(qrcode_value)
                 .as_png(QRCODE_CONFIG[:qrcode])

      IO.binwrite(Rails.root.join(file_folder, image_name), qrcode.to_s)

      file_folder.to_s + '/' + image_name
    rescue => e
      Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")

      ''
    end
  end
end
