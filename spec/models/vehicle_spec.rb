# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Vehicle and Status' do
      vehicle = Vehicle.new

      expect(vehicle).to respond_to(:status)
    end

    it 'validates relationship (N:1) between Vehicle and Team' do
      vehicle = Vehicle.new

      expect(vehicle).to respond_to(:team)
    end
  end

  describe 'validates uniqueness' do
    it 'no validates when license plate is duplicated' do
      vehicle1 = FactoryBot.create(:vehicle)
      vehicle2 = FactoryBot.build(:vehicle, license_plate: vehicle1.license_plate)

      expect(vehicle2).to be_invalid
    end
  end

  describe 'validates presences' do
    it 'of name' do
      vehicle = FactoryBot.build(:vehicle, name: nil)

      expect(vehicle).to be_invalid
    end

    it 'of license_plate' do
      vehicle = FactoryBot.build(:vehicle, license_plate: nil)

      expect(vehicle).to be_invalid
    end

    it 'of color' do
      vehicle = FactoryBot.build(:vehicle, color: nil)

      expect(vehicle).to be_invalid
    end
  end

  describe 'validates license plates' do
    context 'validates vehicle creation' do
      it 'when use default license plate' do
        vehicle = FactoryBot.build(:vehicle, license_plate: 'ABC 1234')

        expect(vehicle).to be_valid
      end

      it 'when use Mercosul license plate' do
        vehicle = FactoryBot.build(:vehicle, license_plate: 'ABC 1B34')

        expect(vehicle).to be_valid
      end
    end

    context 'no validates vehicle creation' do
      it 'when use invalid default license plate' do
        vehicle = FactoryBot.build(:vehicle, license_plate: 'ABC-1234')

        expect(vehicle).to be_invalid
      end

      it 'when use invalid Mercosul license plate' do
        vehicle = FactoryBot.build(:vehicle, license_plate: 'ABC-1B34')

        expect(vehicle).to be_invalid
      end
    end
  end

  describe 'validates scopes' do
    it 'returns only free vehicles' do
      team = FactoryBot.create(:team)
      FactoryBot.create(:vehicle, team: team)
      FactoryBot.create(:vehicle, team: nil)

      expected_result = Vehicle.where(team: nil)

      result = Vehicle.free

      expect(result).to eq(expected_result)
    end

    it 'returns tackle status list' do
      activated_status = FactoryBot.create(:status, name: 'ativo')
      deactivated_status = FactoryBot.create(:status, name: 'desativado')

      result = Vehicle.statuses

      expect(result).to eq([activated_status, deactivated_status])
    end
  end
end
