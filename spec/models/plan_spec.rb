require 'rails_helper'

RSpec.describe Plan, type: :model do
  it 'no validates when not pass code' do
    plan = FactoryBot.build(:plan, code: nil)

    error_message = 'Preenchimento de campo obrigatório!'

    expect(plan).not_to be_valid
    expect(plan.errors.messages[:code]).to include(error_message)
  end

  it 'no validates when not pass name' do
    plan = FactoryBot.build(:plan, name: nil)

    error_message = 'Preenchimento de campo obrigatório!'

    expect(plan).not_to be_valid
    expect(plan.errors.messages[:name]).to include(error_message)
  end

  it 'no validates when not pass price' do
    plan = FactoryBot.build(:plan, price: nil)

    error_message = 'Preenchimento de campo obrigatório!'

    expect(plan).not_to be_valid
    expect(plan.errors.messages[:price]).to include(error_message)
  end

  it 'no validates when not pass status' do
    plan = FactoryBot.build(:plan, status: nil)

    error_message = 'Preenchimento de campo obrigatório!'

    expect(plan).not_to be_valid
    expect(plan.errors.messages[:status]).to include(error_message)
  end

  it 'validates when create a new plan with status as activated' do
    plan = FactoryBot.build(:plan, status: Status::STATUSES[:activated])

    error_message = 'Status inválido!'

    expect(plan).to be_valid
    expect(plan.errors.messages[:status]).not_to include(error_message)
  end

  it 'no validates when plan name isn\'t allowed' do
    plan = FactoryBot.build(:plan, name: 'Anything')

    error_message = 'Nome de plano inválido!'

    expect(plan).not_to be_valid
    expect(plan.errors.messages[:name]).to include(error_message)
  end

  it 'no validates when plan name is duplicated' do
    plan = FactoryBot.create(:plan)
    another_plan = FactoryBot.build(:plan, name: plan.name)

    error_message = 'Nome de plano existente!'

    expect(another_plan).not_to be_valid
    expect(another_plan.errors.messages[:name]).to include(error_message)
  end

  it 'no validates when plan code is duplicated' do
    plan = FactoryBot.create(:plan, code: 'anything')

    another_plan = FactoryBot.build(:plan, code: plan.code)

    error_message = 'Código de plano existente!'

    expect(another_plan).not_to be_valid
    expect(another_plan.errors.messages[:code]).to include(error_message)
  end

  it 'no validates when price is negative' do
    plan = FactoryBot.build(:plan, price: -5.0)

    error_message = 'Preço inválido!'

    expect(plan).not_to be_valid
    expect(plan.errors.messages[:price]).to include(error_message)
  end

  it 'no validates when price is zeroed' do
    plan = FactoryBot.build(:plan, price: 0.0)

    error_message = 'Preço inválido!'

    expect(plan).not_to be_valid
    expect(plan.errors.messages[:price]).to include(error_message)
  end

  it 'returns list containing plan codes that can to storage files' do
    expected_result = ['master-angels', 'premium-angels']

    expect(described_class::PLAN_CODES_WITH_STORAGE).to eq(expected_result)
  end

  describe 'validates relationships' do
    it 'validates relationship 1:N between Plan and Subscribers' do
      plan = Plan.new

      expect(plan).to respond_to(:subscribers)
    end

    it 'validates relationship 1:N between Plan and Subscriptions through Subscribers' do
      plan = Plan.new

      expect(plan).to respond_to(:subscriptions)
    end

    it 'validates relationship 1:N between Plan and Orders through Subscriptions' do
      plan = Plan.new

      expect(plan).to respond_to(:orders)
    end
  end
end
