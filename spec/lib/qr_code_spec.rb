require 'rails_helper'

RSpec.describe QrCode do
  describe '.create!' do
    it 'creates QR Code image' do
      allow(IO).to receive(:binwrite) { Faker::Number.number }

      file_folder = 'tmp'
      file_name = 'google'
      qrcode_value = 'http://google.com.br'

      result = described_class.create!(file_folder: file_folder, file_name: file_name, qrcode_value: qrcode_value)

      expected_result = 'tmp/google.png'

      expect(result).to eq(expected_result)
    end

    it 'no creates QR Code image when occurs some errors' do
      allow(IO).to receive(:binwrite) { raise StandardError }

      file_folder = 'tmp'
      file_name = 'google'
      qrcode_value = 'http://google.com.br'

      result = described_class.create!(file_folder: file_folder, file_name: file_name, qrcode_value: qrcode_value)

      expected_result = 'tmp/google.png'

      expect(result).to eq('')
    end
  end
end
