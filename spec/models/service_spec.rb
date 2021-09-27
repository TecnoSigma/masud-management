# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Service' do
      service = Service.new

      expect(service).to respond_to(:status)
    end

    it 'validates relationship (N:1) between Status and Customer' do
      service = Service.new

      expect(service).to respond_to(:customer)
    end
  end

  describe 'validates presences' do
    it 'of job_day' do
      service = FactoryBot.build(:service, job_day: nil)

      expect(service).to be_invalid
    end

    it 'of source_address' do
      service = FactoryBot.build(:service, source_address: nil)

      expect(service).to be_invalid
    end

    it 'of source_number' do
      service = FactoryBot.build(:service, source_number: nil)

      expect(service).to be_invalid
    end

    it 'of source_district' do
      service = FactoryBot.build(:service, source_district: nil)

      expect(service).to be_invalid
    end

    it 'of source_city' do
      service = FactoryBot.build(:service, source_city: nil)

      expect(service).to be_invalid
    end

    it 'of source_state' do
      service = FactoryBot.build(:service, source_state: nil)

      expect(service).to be_invalid
    end

    it 'of destiny_address' do
      service = FactoryBot.build(:service, destiny_address: nil)

      expect(service).to be_invalid
    end

    it 'of destiny_number' do
      service = FactoryBot.build(:service, destiny_number: nil)

      expect(service).to be_invalid
    end

    it 'of destiny_district' do
      service = FactoryBot.build(:service, destiny_district: nil)

      expect(service).to be_invalid
    end

    it 'of destiny_city' do
      service = FactoryBot.build(:service, destiny_city: nil)

      expect(service).to be_invalid
    end

    it 'of destiy_state' do
      service = FactoryBot.build(:service, destiny_state: nil)

      expect(service).to be_invalid
    end
  end

  describe 'validates allowed status' do
    it 'validates \'agendado\'' do
      status = FactoryBot.create(:status, name: 'agendado')
      service = FactoryBot.build(:service, status: status)

      expect(service).to be_valid
    end

    it 'validates \'confirmado\'' do
      status = FactoryBot.create(:status, name: 'confirmado')
      service = FactoryBot.build(:service, status: status)

      expect(service).to be_valid
    end

    it 'validates \'recusado\'' do
      status = FactoryBot.create(:status, name: 'recusado')
      service = FactoryBot.build(:service, status: status)

      expect(service).to be_valid
    end
  end

  it 'no validates when status isn\'t allowed' do
      status = FactoryBot.create(:status, name: 'invalid status')
      service = FactoryBot.build(:service, status: status)

      expect(service).to be_invalid
    end

  it 'no validates when job day is less than current day' do
    service = FactoryBot.build(:service, job_day: 1.day.ago)

    expect(service).to be_invalid
  end

  describe '#scheduled?' do
    it 'returns \'true\' when the service is scheduled' do
      service = FactoryBot.create(:service, :scheduled)

      result = service.scheduled?

      expect(result).to eq(true)
    end
  end

  describe '#confirmed?' do
    it 'returns \'true\' when the service is confirmed' do
      service = FactoryBot.create(:service, :confirmed)

      result = service.confirmed?

      expect(result).to eq(true)
    end
  end

  describe '#refused?' do
    it 'returns \'true\' when the service is refused' do
      service = FactoryBot.create(:service, :refused)

      result = service.refused?

      expect(result).to eq(true)
    end
  end

  it 'creates an order number when a new order is created' do
    service = FactoryBot.create(:service, :refused)

    result = service.order_number

    expect(result).to be_present
  end
end
