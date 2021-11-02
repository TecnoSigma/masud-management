# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe '.profiles' do
    it 'returns profiles when is production environment' do
      allow(Rails).to receive_message_chain(:env, :production?) { true }

      expected_result = { administrator: 'Administrador', operator: 'Operador' }

      result = described_class.profiles

      expect(result).to eq(expected_result)
    end

    it 'returns profiles when isn\'t production environment' do
      allow(Rails).to receive_message_chain(:env, :production?) { false }

      expected_result = { administrator: 'Administrador',
                          agent: 'Agente',
                          approver: 'Aprovador',
                          lecturer: 'Conferente',
                          operator: 'Operador' }

      result = described_class.profiles

      expect(result).to eq(expected_result)
    end
  end

  describe '.admin?' do
    it 'returns \'true\' when employee is admin' do
      service_token = FactoryBot.create(:service_token)
      FactoryBot.create(:employee, :admin, service_token: service_token)

      result = described_class.admin?(service_token.token)

      expect(result).to eq(true)
    end

    it 'returns \'false\' when employee isn\'t admin' do
      employee = FactoryBot.create(:employee, :operator)
      service_token = FactoryBot.create(:service_token, employee: employee)

      result = described_class.admin?(service_token.token)

      expect(result).to eq(false)
    end
  end

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

    it 'validates optional relationship (1:1) between Service Token and Employee' do
      employee = Employee.new

      expect(employee).to respond_to(:service_token)
    end

    it 'validates optional relationship (1:N) between Employee and Bullet' do
      employee = Employee.new

      expect(employee).to respond_to(:bullets)
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

  it 'no validates when pass invalid CPF' do
    employee = FactoryBot.build(:employee, cpf: '123.456')

    expect(employee).to be_invalid
  end

  it 'no validates when the admission date is greater than current day' do
    employee = FactoryBot.build(:employee, admission_date: 3.days.after)

    expect(employee).to be_invalid
  end

  it 'no validates when the admission date is greater than resignation date' do
    employee = FactoryBot.build(:employee, admission_date: 2.days.after, resignation_date: 2.days.ago)

    expect(employee).to be_invalid
  end
end
