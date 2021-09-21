# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employee, type: :model do
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
    it 'validates relationship (N:1) between Status and Employee' do
      employee = Employee.new

      expect(employee).to respond_to(:status)
    end

    it 'validates relationship (N:N) between Profile and Employee' do
      employee = Employee.new

      expect(employee).to respond_to(:profiles)
    end
  end

  describe 'validates presences' do
    it 'of name' do
      employee = FactoryBot.build(:employee, name: nil)

      expect(employee).to be_invalid
    end

    it 'of email' do
      employee = FactoryBot.build(:employee, email: nil)

      expect(employee).to be_invalid
    end

    it 'of password' do
      employee = FactoryBot.build(:employee, password: nil)

      expect(employee).to be_invalid
    end

    it 'of admission_date' do
      employee = FactoryBot.build(:employee, admission_date: nil)

      expect(employee).to be_invalid
    end

    it 'of rg' do
      employee = FactoryBot.build(:employee, rg: nil)

      expect(employee).to be_invalid
    end

    it 'of cpf' do
      employee = FactoryBot.build(:employee, cpf: nil)

      expect(employee).to be_invalid
    end
  end
end
