# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent, type: :model do
  it 'validates inheritance of Agent with Employee' do
    expect(described_class).to be < Employee
  end

  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Agent' do
      agent = Agent.new

      expect(agent).to respond_to(:status)
    end

    it 'validates relationship (N:1) between Team and Agent' do
      agent = Agent.new

      expect(agent).to respond_to(:team)
    end

    it 'validates relationship (1:N) between Arsenal and Agent' do
      agent = Agent.new

      expect(agent).to respond_to(:arsenals)
    end

    it 'validates relationship (1:N) between Tackle and Agent' do
      agent = Agent.new

      expect(agent).to respond_to(:tackles)
    end
  end

  it 'no validates when pass invalid CVN number' do
    agent = Agent.new(FactoryBot.attributes_for(:employee, :agent, cvn_number: '123456'))

    expect(agent).to be_invalid
  end

  it 'clears password when create a new agent' do
    name = 'João'
    agent = Agent.new(FactoryBot.attributes_for(:employee, :agent, password: '123456', name: name))

    agent.save!

    result = Agent.find_by_name(name).password

    expect(result).to be_nil
  end

  describe 'validates presences' do
    it 'of codename' do
      agent = Agent.new(FactoryBot.attributes_for(:employee, :agent, codename: nil))

      expect(agent).to be_invalid
    end

    it 'of cvn_number' do
      agent = Agent.new(FactoryBot.attributes_for(:employee, :agent, cvn_number: nil))

      expect(agent).to be_invalid
    end

    it 'of cvn_validation_date' do
      agent = Agent.new(FactoryBot.attributes_for(:employee, :agent, cvn_validation_date: nil))

      expect(agent).to be_invalid
    end
  end

  describe 'expired_cvn?' do
    it 'returns \'true\' when CVN is expired' do
      employee = FactoryBot.create(:employee, :agent, cvn_validation_date: Date.yesterday)

      agent = Agent.find_by_name(employee.name)

      result = agent.expired_cvn?

      expect(result).to eq(true)
    end

    it 'returns \'false\' when the CVN expires today' do
      employee = FactoryBot.create(:employee, :agent, cvn_validation_date: Date.today)

      agent = Agent.find_by_name(employee.name)

      result = agent.expired_cvn?

      expect(result).to eq(false)
    end

    it 'returns \'false\' when CVN isn\'t expired' do
      employee = FactoryBot.create(:employee, :agent, cvn_validation_date: Date.tomorrow)

      agent = Agent.find_by_name(employee.name)

      result = agent.expired_cvn?

      expect(result).to eq(false)
    end
  end

  describe '.available' do
    context 'returns list agents' do
      context 'when agent is active' do
        it 'and haven\'t missions' do
          active_status = FactoryBot.create(:status, name: 'ativo')
          employee = FactoryBot.create(:employee, :agent, status: active_status)

          agent = Agent.find(employee.id)

          expected_result = [agent]

          result = Agent.available

          expect(result).to eq(expected_result)
        end

        it 'and the last mission was to more than 13 hours' do
          active_status = FactoryBot.create(:status, name: 'ativo')
          confirmed_status = FactoryBot.create(:status, name: 'confirmado')
          escort_service = EscortService.new(
            FactoryBot.attributes_for(:order, :confirmed, status: confirmed_status)
          )
          team = FactoryBot.create(:team)
          mission = FactoryBot.create(
            :mission,
            team: team,
            escort_service: escort_service,
            started_at: 20.hours.ago,
            finished_at: 14.hours.ago
          )
          employee = FactoryBot.create(:employee, :agent, status: active_status)

          agent = Agent.find(employee.id)
          agent.update(team: team)

          FactoryBot.create(:mission_history, agents: [agent.cvn_number], mission: mission)

          expected_result = [agent]

          result = Agent.available

          expect(result).to eq(expected_result)
        end
      end
    end

    context 'no returns list agents' do
      context 'when agent is active' do
        it 'and the last mission was to less than 13 hours' do
          active_status = FactoryBot.create(:status, name: 'ativo')
          confirmed_status = FactoryBot.create(:status, name: 'confirmado')
          escort_service = EscortService.new(
            FactoryBot.attributes_for(:order, :confirmed, status: confirmed_status)
          )
          team = FactoryBot.create(:team)
          mission = FactoryBot.create(
            :mission,
            team: team,
            escort_service: escort_service,
            started_at: 20.hours.ago,
            finished_at: 12.hours.ago
          )
          employee = FactoryBot.create(:employee, :agent, status: active_status)

          agent = Agent.find(employee.id)
          agent.update(team: team)

          FactoryBot.create(:mission_history, agents: [agent.cvn_number], mission: mission)

          result = Agent.available

          expect(result).to be_empty
        end
      end

      context 'when agent is deactivated' do
        it 'and haven\'t missions' do
          FactoryBot.create(:status, name: 'ativo')
          deactivated_status = FactoryBot.create(:status, name: 'desativado')
          FactoryBot.create(:employee, :agent, status: deactivated_status)

          result = Agent.available

          expect(result).to be_empty
        end

        it 'and have unfinished missions' do
          deactivated_status = FactoryBot.create(:status, name: 'desativado')
          confirmed_status = FactoryBot.create(:status, name: 'confirmado')
          escort_service = EscortService.new(
            FactoryBot.attributes_for(:order, :confirmed, status: confirmed_status)
          )
          team = FactoryBot.create(:team)
          FactoryBot.create(
            :mission,
            team: team,
            escort_service: escort_service,
            started_at: 20.hours.ago,
            finished_at: nil
          )
          employee = FactoryBot.create(:employee, :agent, status: deactivated_status)

          agent = Agent.find(employee.id)
          agent.update(team: team)

          result = Agent.available

          expect(result).to be_empty
        end

        it 'and the last mission was to less more 13 hours' do
          deactivated_status = FactoryBot.create(:status, name: 'desativado')
          confirmed_status = FactoryBot.create(:status, name: 'confirmado')
          escort_service = EscortService.new(
            FactoryBot.attributes_for(:order, :confirmed, status: confirmed_status)
          )
          team = FactoryBot.create(:team)
          FactoryBot.create(
            :mission,
            team: team,
            escort_service: escort_service,
            started_at: 20.hours.ago,
            finished_at: 14.hours.ago
          )
          employee = FactoryBot.create(:employee, :agent, status: deactivated_status)

          agent = Agent.find(employee.id)
          agent.update(team: team)

          result = Agent.available

          expect(result).to be_empty
        end
      end

      context 'when agent is suspended' do
        it 'and haven\'t missions' do
          suspended_status = FactoryBot.create(:status, name: 'suspenso')
          FactoryBot.create(:employee, :agent, status: suspended_status)

          result = Agent.available

          expect(result).to be_empty
        end

        it 'and have unfinished missions' do
          suspended_status = FactoryBot.create(:status, name: 'suspenso')
          confirmed_status = FactoryBot.create(:status, name: 'confirmado')
          escort_service = EscortService.new(
            FactoryBot.attributes_for(:order, :confirmed, status: confirmed_status)
          )
          team = FactoryBot.create(:team)
          FactoryBot.create(
            :mission,
            team: team,
            escort_service: escort_service,
            started_at: 20.hours.ago,
            finished_at: nil
          )
          employee = FactoryBot.create(:employee, :agent, status: suspended_status)

          agent = Agent.find(employee.id)
          agent.update(team: team)

          result = Agent.available

          expect(result).to be_empty
        end

        it 'when the last mission was to more than 13 hours' do
          suspended_status = FactoryBot.create(:status, name: 'suspenso')
          confirmed_status = FactoryBot.create(:status, name: 'confirmado')
          escort_service = EscortService.new(
            FactoryBot.attributes_for(:order, :confirmed, status: confirmed_status)
          )
          team = FactoryBot.create(:team)
          FactoryBot.create(
            :mission,
            team: team,
            escort_service: escort_service,
            started_at: 20.hours.ago,
            finished_at: 14.hours.ago
          )
          employee = FactoryBot.create(:employee, :agent, status: suspended_status)

          agent = Agent.find(employee.id)
          agent.update(team: team)

          result = Agent.available

          expect(result).to be_empty
        end
      end
    end
  end
end
