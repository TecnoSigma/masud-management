require 'rails_helper'

RSpec.describe MissionHistory, type: :model do
  describe 'validates presences' do
    it 'no validates when no pass team' do
      mission_history = FactoryBot.build(:mission_history, team: nil)

      expect(mission_history).to be_invalid
    end

    it 'no validates when no pass agents' do
      mission_history = FactoryBot.build(:mission_history, agents: nil)

      expect(mission_history).to be_invalid
    end

    it 'no validates when no pass items' do
      mission_history = FactoryBot.build(:mission_history, items: nil)

      expect(mission_history).to be_invalid
    end
  end

  describe 'validates relationships' do
    it 'validates relationship (1:1) between Mission History and Mission' do
      mission_history = MissionHistory.new

      expect(mission_history).to respond_to(:mission)
    end
  end
end
