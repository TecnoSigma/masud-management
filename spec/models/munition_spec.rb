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

  describe '.available' do
    context 'caliber is 38' do
      it 'returns only available munition with caliber 38' do
        total_munition = 300
        munition_output = 50
        munition_input = 10
        munition = FactoryBot.create(:arsenal, :munition, quantity: total_munition, kind: '38')
        FactoryBot.create(:item_movimentation, arsenal: munition, quantity: munition_output, output: true)
        FactoryBot.create(:item_movimentation, arsenal: munition, quantity: munition_input, input: true)

        expected_result = 260 # 300-50+10

        result = Munition.find(munition.id).available

        expect(result).to eq(expected_result)
      end
    end

    context 'when caliber is 12' do
      it 'returns only available munition with caliber 12' do
        total_munition = 500
        munition_output = 50
        munition_input = 40
        munition = FactoryBot.create(:arsenal, :munition, quantity: total_munition, kind: '12')
        FactoryBot.create(:item_movimentation, arsenal: munition, quantity: munition_output, output: true)
        FactoryBot.create(:item_movimentation, arsenal: munition, quantity: munition_input, input: true)

        expected_result = 490 # 500-50+40

        result = Munition.find(munition.id).available

        expect(result).to eq(expected_result)
      end
    end
  end
end
