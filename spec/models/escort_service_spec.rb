# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EscortService, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (1:1) between Escort Service and Mission' do
      escort_service = EscortService.new

      expect(escort_service).to respond_to(:mission)
    end
  end

  it 'validates inheritance of EscortService with Escort' do
    expect(described_class).to be < Escort
  end

  describe 'validates presences' do
    it 'of reason when status is \'recusada\'' do
      status = FactoryBot.create(:status, name: 'recusada')
      escort_service = EscortService.new(
        FactoryBot.attributes_for(:order, :refused, status: status, reason: nil)
      )

      expect(escort_service).to be_invalid
    end
  end

  describe 'validates allowed status' do
    it 'validates \'confirmada\'' do
      status = FactoryBot.create(:status, name: 'confirmada')
      escort_service = EscortService.new(
        FactoryBot.attributes_for(:order, :confirmed, status: status)
      )

      expect(escort_service).to be_valid
    end

    it 'validates \'recusada\'' do
      status = FactoryBot.create(:status, name: 'recusada')
      escort_service = EscortService.new(
        FactoryBot.attributes_for(:order, :refused, status: status)
      )

      expect(escort_service).to be_valid
    end
  end

  describe 'no validates when status isn\'t allowed' do
    it 'no validates \'aguardando confirmação\'' do
      status = FactoryBot.create(:status, name: 'aguardando confirmação')
      escort_service = EscortService.new(
        FactoryBot.attributes_for(:order, :confirmed, status: status)
      )

      expect(escort_service).to be_invalid
    end
  end
end
