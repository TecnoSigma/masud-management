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

    it 'validates relationship (1:N) between Clothing and Agent' do
      agent = Agent.new

      expect(agent).to respond_to(:clothes)
    end

    it 'validates relationship (1:N) between Agent and Tackle' do
      agent = Agent.new

      expect(agent).to respond_to(:tackles)
    end
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
end
