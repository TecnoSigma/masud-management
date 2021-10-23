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

    it 'of job_horary' do
      order = FactoryBot.build(:order, job_horary: nil)

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
                                 job_horary: (DateTime.now + 10.minutes).strftime('%H:%M'),
                                 job_day: DateTime.now.strftime('%d/%m/%Y'))

      result = escort.deletable?

      expect(result).to eq(false)
    end

    it 'returns \'true\' when order creation date is greater than 3 hours' do
      customer = FactoryBot.create(:customer)
      status = FactoryBot.create(:status, name: 'agendado')

      escort = FactoryBot.create(:order,
                                 :scheduled,
                                 customer: customer,
                                 status: status,
                                 job_horary: (DateTime.now + 4.hours).strftime('%H:%M'),
                                 job_day: DateTime.now.strftime('%d/%m/%Y'))

      result = escort.deletable?

      expect(result).to eq(true)
    end
  end

  describe 'validates scope that filter escorts by status' do
    context 'agendado' do
      it 'returns scheduled escorts' do
        customer = FactoryBot.create(:customer)
        FactoryBot.create(
          :order,
          :scheduled,
          type: 'EscortScheduling',
          customer: customer
        )

        result = Order.filtered_escorts_by('scheduled')

        expect(result).not_to be_empty
      end
    end

    context 'cancelado pelo cliente' do
      it 'returns scheduled escorts' do
        customer = FactoryBot.create(:customer)
        FactoryBot.create(
          :order,
          :cancelled_by_customer,
          type: 'EscortScheduling',
          customer: customer
        )

        result = Order.filtered_escorts_by('cancelled_by_customer')

        expect(result).not_to be_empty
      end
    end

    context 'recusado' do
      it 'returns scheduled escorts' do
        customer = FactoryBot.create(:customer)
        FactoryBot.create(
          :order,
          :refused,
          type: 'EscortService',
          customer: customer
        )

        result = Order.filtered_escorts_by('refused')

        expect(result).not_to be_empty
      end
    end

    context 'confirmado' do
      it 'returns confirmed escorts' do
        customer = FactoryBot.create(:customer)
        FactoryBot.create(
          :order,
          :confirmed,
          type: 'EscortService',
          customer: customer
        )

        result = Order.filtered_escorts_by('confirmed')

        expect(result).not_to be_empty
      end
    end
  end

  describe '#escort?' do
    it 'returns \'true\' when order is an EscortScheduling' do
      customer = FactoryBot.create(:customer)
      order = FactoryBot.create(
        :order,
        :confirmed,
        type: 'EscortScheduling',
        customer: customer
      )

      result = order.escort?

      expect(result).to eq(true)
    end

    it 'returns \'true\' when order is an EscortService' do
      customer = FactoryBot.create(:customer)
      order = FactoryBot.create(
        :order,
        :confirmed,
        type: 'EscortService',
        customer: customer
      )

      result = order.escort?

      expect(result).to eq(true)
    end
  end

  describe '.children' do
    it 'returns order children list' do
      result = Order.children

      expected_result = %w[EscortScheduling EscortService]

      expect(result).to eq(expected_result)
    end
  end

  describe '.scheduled' do
    it 'returns sorted order by job day in ascendent order' do
      order1 = FactoryBot.create(:order, :scheduled, job_day: '15/02/2050', job_horary: '09:00')
      order2 = FactoryBot.create(:order, :scheduled, job_day: '12/01/2050', job_horary: '10:00')

      expected_result = [EscortScheduling.last, EscortScheduling.first]

      result = described_class.scheduled('EscortScheduling')

      expect(result).to eq(expected_result)
    end
  end
end
