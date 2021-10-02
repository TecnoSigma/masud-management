# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Order' do
      order = Order.new

      expect(order).to respond_to(:status)
    end

    it 'validates relationship (N:1) between Status and Customer' do
      order = Order.new

      expect(order).to respond_to(:customer)
    end
  end

  describe 'validates presences' do
    it 'of job_day' do
      order = FactoryBot.build(:order, job_day: nil)

      expect(order).to be_invalid
    end

    it 'of source_address' do
      order = FactoryBot.build(:order, source_address: nil)

      expect(order).to be_invalid
    end

    it 'of source_number' do
      order = FactoryBot.build(:order, source_number: nil)

      expect(order).to be_invalid
    end

    it 'of source_district' do
      order = FactoryBot.build(:order, source_district: nil)

      expect(order).to be_invalid
    end

    it 'of source_city' do
      order = FactoryBot.build(:order, source_city: nil)

      expect(order).to be_invalid
    end

    it 'of source_state' do
      order = FactoryBot.build(:order, source_state: nil)

      expect(order).to be_invalid
    end

    it 'of destiny_address' do
      order = FactoryBot.build(:order, destiny_address: nil)

      expect(order).to be_invalid
    end

    it 'of destiny_number' do
      order = FactoryBot.build(:order, destiny_number: nil)

      expect(order).to be_invalid
    end

    it 'of destiny_district' do
      order = FactoryBot.build(:order, destiny_district: nil)

      expect(order).to be_invalid
    end

    it 'of destiny_city' do
      order = FactoryBot.build(:order, destiny_city: nil)

      expect(order).to be_invalid
    end

    it 'of destiy_state' do
      order = FactoryBot.build(:order, destiny_state: nil)

      expect(order).to be_invalid
    end
  end

  describe 'validates allowed status' do
    it 'validates \'agendado\'' do
      status = FactoryBot.create(:status, name: 'agendado')
      order = FactoryBot.build(:order, status: status)

      expect(order).to be_valid
    end

    it 'validates \'confirmado\'' do
      status = FactoryBot.create(:status, name: 'confirmado')
      order = FactoryBot.build(:order, status: status)

      expect(order).to be_valid
    end

    it 'validates \'recusado\'' do
      status = FactoryBot.create(:status, name: 'recusado')
      order = FactoryBot.build(:order, status: status)

      expect(order).to be_valid
    end
  end

  it 'no validates when status isn\'t allowed' do
    status = FactoryBot.create(:status, name: 'invalid status')
    order = FactoryBot.build(:order, status: status)

    expect(order).to be_invalid
  end

  it 'no validates when job day is less than current day' do
    order = FactoryBot.build(:order, job_day: 1.day.ago)

    expect(order).to be_invalid
  end

  describe '#scheduled?' do
    it 'returns \'true\' when the order is scheduled' do
      order = FactoryBot.create(:order, :scheduled)

      result = order.scheduled?

      expect(result).to eq(true)
    end
  end

  describe '#confirmed?' do
    it 'returns \'true\' when the order is confirmed' do
      order = FactoryBot.create(:order, :confirmed)

      result = order.confirmed?

      expect(result).to eq(true)
    end
  end

  describe '#refused?' do
    it 'returns \'true\' when the order is refused' do
      order = FactoryBot.create(:order, :refused)

      result = order.refused?

      expect(result).to eq(true)
    end
  end

  it 'creates an order number when a new order is created' do
    order = FactoryBot.create(:order, :refused)

    result = order.order_number

    expect(result).to be_present
  end

  describe '#deletable?' do
    it 'returns \'true\' when order creation date is less than 3 hours' do
      customer = FactoryBot.create(:customer)
      status = FactoryBot.create(:status, name: 'agendado')

      escort = FactoryBot.create(:order,
                                 :scheduled,
                                 customer: customer,
                                 status: status,
                                 created_at: 2.hours.ago)

      result = escort.deletable?

      expect(result).to eq(true)
    end

    it 'returns \'true\' when order creation date is equal to 3 hours' do
      customer = FactoryBot.create(:customer)
      status = FactoryBot.create(:status, name: 'agendado')

      escort = FactoryBot.create(:order,
                                 :scheduled,
                                 customer: customer,
                                 status: status,
                                 created_at: 3.hours.ago)

      result = escort.deletable?

      expect(result).to eq(true)
    end

    it 'returns \'true\' when order creation date is greater than 3 hours' do
      customer = FactoryBot.create(:customer)
      status = FactoryBot.create(:status, name: 'agendado')

      escort = FactoryBot.create(:order,
                                 :scheduled,
                                 customer: customer,
                                 status: status,
                                 created_at: 4.hours.ago)

      result = escort.deletable?

      expect(result).to eq(false)
    end
  end
end
