require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe 'validates presence' do
    it 'no validates when not pass vehicle brand' do
      vehicle = FactoryBot.build(:vehicle, brand: nil)

      expect(vehicle).to be_invalid
      expect(vehicle.errors.messages[:brand]).to include('Preenchimento de campo obrigatório!')
    end

    it 'no validates when not pass vehicle kind' do
      vehicle = FactoryBot.build(:vehicle, kind: nil)

      expect(vehicle).to be_invalid
      expect(vehicle.errors.messages[:kind]).to include('Preenchimento de campo obrigatório!')
    end 

    it 'no validates when not pass vehicle license plate' do
      vehicle = FactoryBot.build(:vehicle, license_plate: nil)

      expect(vehicle).to be_invalid
      expect(vehicle.errors.messages[:license_plate]).to include('Preenchimento de campo obrigatório!')
    end 
  end

  describe 'validates uniqueness' do
    it 'no validates when pass duplicated license plate' do
      vehicle_1 = FactoryBot.create(:vehicle)
      vehicle_2 = FactoryBot.build(:vehicle, license_plate: vehicle_1.license_plate)

      expect(vehicle_2).to be_invalid
      expect(vehicle_2.errors.messages[:license_plate]).to include('Placa existente!')
    end
  end

  describe 'validates REGEX' do
    it 'no validates when pass invalid regex' do
      vehicle = FactoryBot.build(:vehicle, license_plate: 'AS-1204')

      expect(vehicle).to be_invalid
      expect(vehicle.errors.messages[:license_plate]).to include('Formato inválido!')
    end
  end

  describe 'validates relationships' do
    it ' validates relationship N:1 betweeen vehicles and subscriber' do
      vehicle = Vehicle.new

      expect(vehicle).to respond_to(:subscriber)
    end

    it 'validates relationship N:N betweeen vehicles and drivers' do
      vehicle = Vehicle.new

      expect(vehicle).to respond_to(:drivers)
    end 
  end

  it 'validates vehicle only when pass allowed status' do
    vehicle = FactoryBot.build(:vehicle, status: Status::STATUSES[:pendent])

    expect(vehicle).to be_invalid
    expect(vehicle.errors.messages[:status]).to include('Status inválido!')
  end

  it 'validates scope that sort vehicle by license plate' do
    subscriber = FactoryBot.create(:subscriber)
    subscriber.status = Status::STATUSES[:activated]
    subscriber.save!

    vehicle1 = FactoryBot.create(:vehicle, license_plate: 'XYZ-9999', subscriber: subscriber)
    vehicle2 = FactoryBot.create(:vehicle, license_plate: 'ABC-1111', subscriber: subscriber)

    result = described_class.sort_by_license_plate

    expect(result).to eq([vehicle2, vehicle1])
  end

  it 'attaches many photos' do
    subscriber = FactoryBot.create(:subscriber)
    subscriber.status = Status::STATUSES[:activated]
    subscriber.save!

    vehicle = FactoryBot.build(:vehicle, subscriber: subscriber)

    expect(vehicle).to respond_to(:photos)
  end

  it 'no validates when a photos quantity is diferent of 3' do
    subscriber = FactoryBot.create(:subscriber)
    subscriber.status = Status::STATUSES[:activated]
    subscriber.save!

    file_list = [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/front_photo.jpg"),
                 Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/back_photo.jpg")]

    vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
    vehicle.photos.attach(file_list)
    
    vehicle.valid?

    expect(vehicle.errors.messages[:photos]).to include('Quantidade de foto não permitida!')
  end

  it 'attaches only one document' do
    subscriber = FactoryBot.build(:driver)

    expect(subscriber).to respond_to(:document)
  end

  describe '#have_photos?' do
    it 'returns \'true\' when vehicle have photos' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      result = vehicle.have_photos?

      expect(result).to eq(true)
    end

    it 'returns \'false\' when vehicle haven\'t photos' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

      result = vehicle.have_photos?

      expect(result).to eq(false)
    end
  end

  it 'no validates when vehicle have somebody photo without allowed size' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

      file_list = [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/front_photo.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/earth.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/back_photo.jpg")]

      vehicle.photos.attach(file_list)

      expect(vehicle.valid?).to eq(false)
    end

  it 'no validates when vehicle have somebody photo without allowed content types' do
    subscriber = FactoryBot.create(:subscriber)
    subscriber.status = Status::STATUSES[:activated]
    subscriber.save!

    vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

    file_list = [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/front_photo.jpg"),
                 Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/object.txt"),
                 Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/back_photo.jpg")]

    vehicle.photos.attach(file_list)

    expect(vehicle.valid?).to eq(false)
  end
end
