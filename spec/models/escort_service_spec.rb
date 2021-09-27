# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EscortService, type: :model do
  it 'validates inheritance of EscortService with Escort' do
    expect(described_class).to be < Escort
  end

  describe 'validates presences' do
    it 'of reason when status is \'recusado\'' do
      status = FactoryBot.create(:status, name: 'recusado')
      escort_service = EscortService.new(
        FactoryBot.attributes_for(:order, :refused, status: status, reason: nil)
      )

      expect(escort_service).to be_invalid
    end
  end

  describe 'validates allowed status' do
    it 'validates \'confirmado\'' do
      status = FactoryBot.create(:status, name: 'confirmado')
      escort_service = EscortService.new(
        FactoryBot.attributes_for(:order, :confirmed, status: status)
      )

      expect(escort_service).to be_valid
    end

    it 'validates \'recusado\'' do
      status = FactoryBot.create(:status, name: 'recusado')
      escort_service = EscortService.new(
        FactoryBot.attributes_for(:order, :refused, status: status)
      )

      expect(escort_service).to be_valid
    end
  end

  describe 'no validates when status isn\'t allowed' do
    it 'no validates \'agendado\'' do
      status = FactoryBot.create(:status, name: 'agendado')
      escort_service = EscortService.new(
        FactoryBot.attributes_for(:order, :confirmed, status: status)
      )

      expect(escort_service).to be_invalid
    end
  end
end
