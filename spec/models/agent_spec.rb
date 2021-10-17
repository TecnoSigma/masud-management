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

    it 'validates relationship (1:N) between Agent and Tackle' do
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
end
