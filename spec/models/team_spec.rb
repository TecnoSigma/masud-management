# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (1:N) between Team and Agent' do
      team = Team.new

      expect(team).to respond_to(:agents)
    end

    it 'validates relationship (1:N) between Team and Vehicle' do
      team = Team.new

      expect(team).to respond_to(:vehicles)
    end

    it 'validates relationship (1:1) between Team and Mission' do
      team = Team.new

      expect(team).to respond_to(:mission)
    end
  end

  it 'validates presence of name' do
    team = FactoryBot.build(:team, name: nil)

    expect(team).to be_invalid
  end

  describe 'validates scopes' do
    it 'returns available teams' do
      team = FactoryBot.create(:team)

      result = Team.available

      expect(result).to eq([team])
    end
  end

  it 'returns valid team prefix' do
    team_prefix = 'M'

    result = Team::PREFIX

    expect(result).to eq(team_prefix)
  end

  it 'returns maximum quantity teams' do
    maximum_quantity = 99

    result = Team::MAXIMUM_QUANTITY

    expect(result).to eq(maximum_quantity)
  end
end
