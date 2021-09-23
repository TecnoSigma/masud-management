# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Vehicle and Status' do
      vehicle = Vehicle.new

      expect(vehicle).to respond_to(:status)
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
end
