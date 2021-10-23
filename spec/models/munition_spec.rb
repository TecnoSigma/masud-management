# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Munition, type: :model do
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

  describe 'validates scopes' do
    context 'when is a munition' do
      context 'caliber is 38' do
        it 'returns only free munition with caliber 38' do
          FactoryBot.create(:arsenal, :munition, employee: nil, kind: '12')
          FactoryBot.create(:arsenal, :munition, employee: nil, kind: '38')

          expected_result = Munition.where(kind: '38').where(employee: nil)

          result = Munition.free('38')

          expect(result).to eq(expected_result)
        end
      end

      context 'caliber is 12' do
        it 'returns only free munition with caliber 12' do
          FactoryBot.create(:arsenal, :munition, employee: nil, kind: '12')
          FactoryBot.create(:arsenal, :munition, employee: nil, kind: '38')

          expected_result = Munition.where(kind: '12').where(employee: nil)

          result = Munition.free('12')

          expect(result).to eq(expected_result)
        end
      end
    end
  end
end
