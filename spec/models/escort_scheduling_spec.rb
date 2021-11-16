# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EscortScheduling, type: :model do
  it 'validates inheritance of EscortScheduling with Escort' do
    expect(described_class).to be < Escort
  end

  describe 'validates allowed status' do
    it 'validates \'aguardando confirmação\'' do
      status = FactoryBot.create(:status, name: 'aguardando confirmação')
      escort_scheduling = EscortScheduling.new(
        FactoryBot.attributes_for(:order, :scheduled, status: status)
      )

      expect(escort_scheduling).to be_valid
    end
  end

  describe 'no validates when status isn\'t allowed' do
    it 'no validates \'confirmada\'' do
      status = FactoryBot.create(:status, name: 'confirmada')
      escort_scheduling = EscortScheduling.new(
        FactoryBot.attributes_for(:order, :scheduled, status: status)
      )

      expect(escort_scheduling).to be_invalid
    end

    it 'no validates \'recusada\'' do
      status = FactoryBot.create(:status, name: 'recusada')
      escort_scheduling = EscortScheduling.new(
        FactoryBot.attributes_for(:order, :scheduled, status: status)
      )

      expect(escort_scheduling).to be_invalid
    end
  end
end
