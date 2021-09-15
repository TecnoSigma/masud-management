require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'no validates when status is null' do
    error_message = 'Preenchimento de campo obrigatório!'

    order = FactoryBot.build(:order, status: nil)

    expect(order.valid?).to be_falsey
    expect(order.errors.messages[:status]).to include(error_message)
  end

  it 'no validates when status is approved and approved date is null' do
    error_message = 'Preenchimento de campo obrigatório!'

    order = FactoryBot.build(:order, status: Status::ORDER_STATUSES[:approved], approved_at: nil)

    expect(order.valid?).to be_falsey
    expect(order.errors.messages[:approved_at]).to include(error_message)
  end

  it 'adds code when order is created' do
    seller = FactoryBot.create(:seller)
    subscriber = FactoryBot.create(:subscriber)
    subscription = FactoryBot.create(:subscription, subscriber: subscriber)
    order = FactoryBot.create(:order, subscription: subscription, seller: seller)

    result = order.code

    expect(result).to be_present
  end

  describe 'validates scopes' do
    it 'sort order list by sale date' do
      seller = FactoryBot.create(:seller)

      subscriber = FactoryBot.create(:subscriber)
      subscription = FactoryBot.create(:subscription, subscriber: subscriber)

      order_1 = FactoryBot.create(:order,
                                  price: 100.0,
                                  status: Status::ORDER_STATUSES[:approved],
                                  seller: seller,
                                  subscription: subscription,
                                  created_at: DateTime.yesterday,
                                  approved_at: DateTime.now)
      order_2 = FactoryBot.create(:order,
                                  price: 100.0,
                                  status: Status::ORDER_STATUSES[:approved],
                                  seller: seller,
                                  subscription: subscription,
                                  created_at: DateTime.now,
                                  approved_at: DateTime.now)

      result = Order.by_sale_date

      expect(result).to eq([order_2, order_1])
    end

    it 'sum the sales totals by status' do
      seller = FactoryBot.create(:seller)

      subscriber = FactoryBot.create(:subscriber)
      subscription = FactoryBot.create(:subscription, subscriber: subscriber)

      order_1 = FactoryBot.create(:order,
                                  price: 100.0,
                                  status: Status::ORDER_STATUSES[:approved],
                                  seller: seller,
                                  subscription: subscription,
                                  approved_at: DateTime.now)
      order_2 = FactoryBot.create(:order,
                                  price: 20.0,
                                  status: Status::ORDER_STATUSES[:refused],
                                  seller: seller,
                                  subscription: subscription)
      order_3 = FactoryBot.create(:order,
                                  price: 10.0,
                                  status: Status::ORDER_STATUSES[:approved],
                                  seller: seller,
                                  subscription: subscription,
                                  approved_at: DateTime.now)

      result_1 = Order.totals_by_status(Status::ORDER_STATUSES[:approved])
      result_2 = Order.totals_by_status(Status::ORDER_STATUSES[:refused])

      expect(result_1).to eq(order_1.price + order_3.price)
      expect(result_2).to eq(order_2.price)
    end
  end

  describe 'validates relationships' do
    it 'validates relationship 1:1 between Order and Subscription' do
      order = Order.new

      expect(order).to respond_to(:subscription)
    end

    it 'validates relationship N:1 between Order and Seller' do
      order = Order.new

      expect(order).to respond_to(:seller)
    end
  end
end
