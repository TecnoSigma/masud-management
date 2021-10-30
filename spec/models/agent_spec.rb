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
    it 'keeps the beginner agent as first of agent list when returns agent list' do
      active_status = FactoryBot.create(:status, name: 'ativo')
      employee1 = FactoryBot.create(:employee,
                                    :agent,
                                    status: active_status,
                                    last_mission: 14.hours.ago,
                                    in_mission: false)

      employee2 = FactoryBot.create(:employee,
                                    :agent,
                                    status: active_status,
                                    last_mission: nil)

      beginner = Agent.find(employee2.id)
      rested = Agent.find(employee1.id)

      expected_result = [beginner, rested]

      result = Agent.available

      expect(result).to eq(expected_result)
    end

    context 'returns list agents' do
      context 'when agent is active' do
        it 'and is a beginner' do
          active_status = FactoryBot.create(:status, name: 'ativo')
          employee = FactoryBot.create(:employee,
                                       :agent,
                                       status: active_status,
                                       last_mission: nil)

          agent = Agent.find(employee.id)

          expected_result = [agent]

          result = Agent.available

          expect(result).to eq(expected_result)
        end

        it 'and is rested was to more than 13 hours' do
          active_status = FactoryBot.create(:status, name: 'ativo')
          employee = FactoryBot.create(:employee,
                                       :agent,
                                       status: active_status,
                                       last_mission: 14.hours.ago,
                                       in_mission: false)

          agent = Agent.find(employee.id)

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
          FactoryBot.create(:employee,
                            :agent,
                            status: active_status,
                            last_mission: 12.hours.ago,
                            in_mission: false)

          result = Agent.available

          expect(result).to be_empty
        end

        it 'and the last mission isn\'t finished' do
          active_status = FactoryBot.create(:status, name: 'ativo')
          FactoryBot.create(:employee,
                            :agent,
                            status: active_status,
                            last_mission: 14.hours.ago,
                            in_mission: true)

          result = Agent.available

          expect(result).to be_empty
        end
      end

      it 'when agent is deactivated' do
        deactivated_status = FactoryBot.create(:status, name: 'desativado')
        FactoryBot.create(:employee, :agent, status: deactivated_status)

        result = Agent.available

        expect(result).to be_empty
      end

      it 'when agent is suspended' do
        suspended_status = FactoryBot.create(:status, name: 'suspenso')
        FactoryBot.create(:employee, :agent, status: suspended_status)

        result = Agent.available

        expect(result).to be_empty
      end
    end
  end
end
