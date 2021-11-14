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

  describe '#finished_escorts' do
    it 'returns only finished escort services' do
      FactoryBot.create(:status, name: 'iniciada')
      FactoryBot.create(:status, name: 'finalizada')

      employee1 = FactoryBot.create(:employee, :agent)
      agent1 = Agent.find(employee1.id)

      team1 = FactoryBot.create(:team)
      team1.agents << agent1
      team1.save

      order1 = FactoryBot.create(:order, :confirmed)
      escort_service1 = EscortService.find(order1.id)
      customer1 = escort_service1.customer

      FactoryBot.create(:mission,
                        team: team1,
                        escort_service: escort_service1,
                        finished_at: DateTime.now)

      employee2 = FactoryBot.create(:employee, :agent)
      agent2 = Agent.find(employee2.id)

      team2 = FactoryBot.create(:team)
      team2.agents << agent2
      team2.save

      order2 = FactoryBot.create(:order, :confirmed)
      escort_service2 = EscortService.find(order2.id)
      customer2 = escort_service2.customer

      FactoryBot.create(:mission,
                        team: team2,
                        escort_service: escort_service2,
                        finished_at: nil)

      result1 = customer1.finished_escorts
      result2 = customer2.finished_escorts

      expect(result1).to eq([escort_service1])
      expect(result2).not_to eq([escort_service2])
    end
  end

  it 'generates password when create a new customer' do
    company = 'XPTO S.A.'
    customer = FactoryBot.build(:customer, company: company, password: nil)

    customer.save!

    result = Customer.find_by_company(company).password

    expect(result).to be_present
  end

  it 'returns allowed status to customers' do
    activate_status = FactoryBot.create(:status, name: 'ativo')
    deactivate_status = FactoryBot.create(:status, name: 'desativado')
    FactoryBot.create(:status, name: 'other_status')

    result = Customer.statuses

    expect(result).to eq([activate_status, deactivate_status])
  end
end
