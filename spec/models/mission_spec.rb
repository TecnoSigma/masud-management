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
end
