require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it 'no validates when not pass code' do
    error_message = 'Preenchimento de campo obrigatório!'
    subscriber = FactoryBot.build(:subscription, code: nil)

    expect(subscriber).to be_invalid
    expect(subscriber.errors.messages[:code]).to include(error_message)
  end

  it 'no validates when not pass status' do
    error_message = 'Preenchimento de campo obrigatório!'
    subscriber = FactoryBot.build(:subscription, status: nil)

    expect(subscriber).to be_invalid
    expect(subscriber.errors.messages[:status]).to include(error_message)
  end

  it 'no validates when not pass code' do
    error_message = 'Preenchimento de campo obrigatório!'
    subscriber = FactoryBot.build(:subscription, code: nil)

    expect(subscriber).to be_invalid
    expect(subscriber.errors.messages[:code]).to include(error_message)
  end

  describe '.code' do
    it 'ahould return subscription code' do
      uuid = 'abc12345'
      allow(SecureRandom).to receive(:uuid) { uuid }

      expect(Subscription.code).to eq("subscription-#{uuid}")
    end
  end

  describe '.payment_method' do
    it 'returns payment method as Credit Card when pass \'Cartão de Crédito\'' do
      expect(Subscription.payment_method('Cartão de Crédito')).to eq('CREDIT_CARD')
    end
  end

  it 'returns only pendent subscriptions' do
    subscriber = FactoryBot.create(:subscriber)
    subscriber.update_attributes!(status: 'ativado')

    subscription_1 = FactoryBot.create(:subscription,  status: 'pendente', subscriber: subscriber)
    subscription_2 = FactoryBot.create(:subscription,  status: 'ativado', subscriber: subscriber)

    result = described_class.pendents

    expect(result).to include(subscription_1)
    expect(result).not_to include(subscription_2)
  end

  it 'returns only activated subscriptions' do
    subscriber = FactoryBot.create(:subscriber)
    subscriber.update_attributes!(status: 'ativado')

    subscription_1 = FactoryBot.create(:subscription, status: 'ativado', subscriber: subscriber)
    subscription_2 = FactoryBot.create(:subscription, status: 'desativado', subscriber: subscriber )

    result = Subscription.activated

    expect(result).to include(subscription_1)
    expect(result).not_to include(subscription_2)
  end

  it 'returns only deactivated subscriptions' do
    subscriber = FactoryBot.create(:subscriber)
    subscriber.update_attributes!(status: 'desativado')

    subscription_1 = FactoryBot.create(:subscription, status: 'desativado', subscriber: subscriber)
    subscription_2 = FactoryBot.create(:subscription, status: 'ativado', subscriber: subscriber )

    result = Subscription.deactivated

    expect(result).to include(subscription_1)
    expect(result).not_to include(subscription_2)
  end

  describe 'validates relationships' do
    it 'validates relationship 1:N between Subscription and Order' do
      subscription = Subscription.new

      expect(subscription).to respond_to(:order)
    end
  end
end
