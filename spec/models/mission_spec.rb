# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mission, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (1:1) between Mission and Escort Service' do
      mission = Mission.new

      expect(mission).to respond_to(:escort_service)
    end

    it 'validates relationship (1:1) between Mission and Mission History' do
      mission = Mission.new

      expect(mission).to respond_to(:mission_history)
    end

    it 'validates relationship (N:1) between Mission and Team' do
      mission = Mission.new

      expect(mission).to respond_to(:team)
    end

    it 'validates relationship (N:1) between Mission and Status' do
      mission = Mission.new

      expect(mission).to respond_to(:status)
    end
  end

  describe '#started?' do
    it 'returns \'true\' when mission is started' do
      FactoryBot.create(:status, name: 'confirmada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission,
                                  team: team,
                                  escort_service:
                                  escort_service,
                                  started_at: DateTime.now)

      expect(mission.started?).to eq(true)
    end

    it 'returns \'false\' when mission isn\'t started' do
      FactoryBot.create(:status, name: 'confirmada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission,
                                  team: team,
                                  escort_service:
                                  escort_service,
                                  started_at: nil)

      expect(mission.started?).to eq(false)
    end
  end
end
