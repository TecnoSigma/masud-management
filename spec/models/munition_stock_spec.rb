# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MunitionStock, type: :model do
  describe 'validates presences' do
    it 'of caliber' do
      stock = FactoryBot.build(:munition_stock, caliber: nil)

      expect(stock).to be_invalid
    end

    it 'of quantity' do
      stock = FactoryBot.build(:munition_stock, quantity: nil)

      expect(stock).to be_invalid
    end

    it 'of last update' do
      stock = FactoryBot.build(:munition_stock, last_update: nil)

      expect(stock).to be_invalid
    end
  end

  describe 'validates numericality' do
    it 'no validates when quantity is a float number' do
      munition = FactoryBot.build(:munition_stock, quantity: 1.5)

      expect(munition).to be_invalid
    end

    it 'no validates when quantity is less than zero' do
      munition = FactoryBot.build(:munition_stock, quantity: -10)

      expect(munition).to be_invalid
    end
  end
end
