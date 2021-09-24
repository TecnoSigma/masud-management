# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gun, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Gun' do
      munition = Munition.new

      expect(munition).to respond_to(:status)
    end

    it 'validates relationship (N:1) between Employee and Gun' do
      munition = Munition.new

      expect(munition).to respond_to(:employee)
    end
  end

  describe 'validates presences' do
    it 'of quantity' do
      munition = Munition.new(FactoryBot.attributes_for(:arsenal, :munition, quantity: nil))

      expect(munition).to be_invalid
    end

    it 'of kind' do
      munition = Munition.new(FactoryBot.attributes_for(:arsenal, :munition, kind: nil))

      expect(munition).to be_invalid
    end
  end
end
