# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe '#active?' do
    it 'returns \'true\' whe customer is active' do
      status = FactoryBot.create(:status, name: 'ativo')
      customer = FactoryBot.create(:customer, status: status)

      result = customer.active?

      expect(result).to eq(true)
    end

    it 'returns \'false\' when customer isn\'t active' do
      status = FactoryBot.create(:status, name: 'desativado')
      customer = FactoryBot.create(:customer, status: status)

      result = customer.active?

      expect(result).to eq(false)
    end
  end

  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Customer' do
      customer = Customer.new

      expect(customer).to respond_to(:status)
    end

    it 'validates relationship (1:N) between Customer and Order' do
      customer = Customer.new

      expect(customer).to respond_to(:orders)
    end

    it 'validates optional relationship (1:1) between Service Token and Customer' do
      customer = Customer.new

      expect(customer).to respond_to(:service_token)
    end
  end

  describe 'validates presences' do
    it 'of company' do
      customer = FactoryBot.build(:customer, company: nil)

      expect(customer).to be_invalid
    end

    it 'of cnpj' do
      customer = FactoryBot.build(:customer, cnpj: nil)

      expect(customer).to be_invalid
    end

    it 'of email' do
      customer = FactoryBot.build(:customer, email: nil)

      expect(customer).to be_invalid
    end

    it 'of password' do
      customer = FactoryBot.build(:customer, password: nil)

      expect(customer).to be_invalid
    end
  end

  describe '#escorts' do
    it 'lists customer escorts ordered by job day (desc)' do
      customer = FactoryBot.build(:customer)

      FactoryBot.create(:order, :scheduled, job_day: 10.days.after, customer: customer)
      FactoryBot.create(:order, :scheduled, job_day: 2.days.after, customer: customer)

      expected_result = [EscortScheduling.last, EscortScheduling.first]

      result = customer.escorts

      expect(result).to eq(expected_result)
    end
  end
end
