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
end
