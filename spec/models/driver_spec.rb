require 'rails_helper'

RSpec.describe Driver, type: :model do
  it 'does not validate when pass name as null' do
    driver = FactoryBot.build(:driver, name: nil)

    expect(driver).to be_invalid
    expect(driver.errors[:name]).to include('Preenchimento de campo obrigatório!')
  end

  it 'does not validate when pass code as null' do
    driver = FactoryBot.build(:driver, code: nil)

    expect(driver).to be_invalid
    expect(driver.errors[:code]).to include('Preenchimento de campo obrigatório!')
  end

  it 'does not validate when pass paid activity as null' do
    driver = FactoryBot.build(:driver, paid_activity: nil)

    expect(driver).to be_invalid
    expect(driver.errors[:paid_activity]).to include('Preenchimento de campo obrigatório!')
  end

  it 'does not validate when pass driver license as null' do
    driver = FactoryBot.build(:driver, license: nil)

    expect(driver).to be_invalid
    expect(driver.errors[:license]).to include('Preenchimento de campo obrigatório!')
  end

  it 'does not validate when pass expedition date as null' do
    driver = FactoryBot.build(:driver, expedition_date: nil)

    expect(driver).to be_invalid
    expect(driver.errors[:expedition_date]).to include('Preenchimento de campo obrigatório!')
  end

  it 'does not validate when pass expiration date as null' do
    driver = FactoryBot.build(:driver, expiration_date: nil)

    expect(driver).to be_invalid
    expect(driver.errors[:expiration_date]).to include('Preenchimento de campo obrigatório!')
  end

  it 'does not validate when pass status as null' do
    driver = FactoryBot.build(:driver, status: nil)

    expect(driver).to be_invalid
    expect(driver.errors[:status]).to include('Preenchimento de campo obrigatório!')
  end

  it 'does not validate when driver license expiration is greater than 30 days' do
    driver = FactoryBot.build(:driver, expiration_date: 40.days.ago)

    expect(driver).to be_invalid
    expect(driver.errors[:expiration_date]).to include('A data de expiração da CNH não pode ser maior que 30 dias')
  end

  it 'does not validate when expedition date is greater than current date' do
    driver = FactoryBot.build(:driver, expedition_date: DateTime.tomorrow)

    expect(driver).to be_invalid
    expect(driver.errors[:expedition_date]).to include('A data de expedição não pode ser maior que a data-corrente!')
  end

  it 'does not validate when driver license format is invalid' do
    driver = FactoryBot.build(:driver, license: 'ABC123456789')

    expect(driver).to be_invalid
    expect(driver.errors[:license]).to include('Formato inválido!')
  end

  describe 'validates relationships' do
    it 'validates relationsip (N:N) between Driver and Vehicles' do
      driver = Driver.new

      expect(driver).to respond_to(:vehicles)
    end

    it 'validates relationship (1:N) between Driver and Rating' do
      driver = Driver.new

      expect(driver).to respond_to(:ratings)
    end

    it 'validates relationship N:N between Driver and Angel' do
      driver = Driver.new

      expect(driver).to respond_to(:angels)
    end
  end

  it 'returns driver data list containing name and driver license number' do
    subscriber = FactoryBot.create(:subscriber)
    subscriber.update_attributes!(status: Status::STATUSES[:activated])

    vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
    add_vehicle_photos(vehicle_1)

    vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)
    add_vehicle_photos(vehicle_2)

    driver_1 = FactoryBot.create(:driver, vehicles: [vehicle_1])
    driver_2 = FactoryBot.create(:driver, vehicles: [vehicle_2])

    result = described_class.licenses
    expected_result = [[driver_1.license, driver_1.name], [driver_2.license, driver_2.name]]

    expect(result).to eq(expected_result)
  end

  it 'attaches only one QR Code' do
    subscriber = FactoryBot.build(:driver)

    expect(subscriber).to respond_to(:qrcode)
  end

  it 'attaches only one document' do
    subscriber = FactoryBot.build(:driver)

    expect(subscriber).to respond_to(:document)
  end

  it 'attaches only one photo' do
    subscriber = FactoryBot.build(:driver)

    expect(subscriber).to respond_to(:photo)
  end

  describe '#create_qrcode!' do
    it 'creates driver QR Code in storage folder' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      allow(QrCode).to receive(:create!) { "qr_codes/#{driver.code}" }
      allow(driver).to receive(:send_qrcode_to_storage!) { true }

      result = driver.create_qrcode!

      expect(result).to eq(true)
    end

    it 'no creates driver QR Code in storage folder when occurs some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      allow(QrCode).to receive(:create!) { "qr_codes/#{driver.code}" }
      allow(File).to receive(:open) { raise StandardError }

      result = driver.create_qrcode!

      expect(result).to eq(false)
    end
  end

  describe '#transmission_url' do
    it 'returns transmission URL' do
      uuid = SecureRandom.uuid

      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      allow(SecureRandom).to receive(:uuid) { uuid }

      result = driver.transmission_url

      expect(result).to eq("http://localhost:3000/transmissao/driver-#{uuid}")
    end
  end
end
