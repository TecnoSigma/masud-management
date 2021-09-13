require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe '' do
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

    it 'validates relationship (1:N) between Customer and Escort' do
      customer = Customer.new

      expect(customer).to respond_to(:escorts)
    end
  end

  describe 'validates presences' do
    it 'of email' do
      customer = FactoryBot.build(:customer, email: nil)

      expect(customer).to be_invalid
    end

    it 'of password' do
      customer = FactoryBot.build(:customer, password: nil)

      expect(customer).to be_invalid
    end
  end
end
