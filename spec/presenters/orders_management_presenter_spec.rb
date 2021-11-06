# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersManagementPresenter do
  describe '#available_agents' do
    it 'returns available agents mounting list containing agents quantity' do
      FactoryBot.create(:employee, :agent)

      expected_result = (0..Agent.count).to_a

      result = described_class.available_agents

      expect(result).to eq(expected_result)
    end

    it 'returns empty list when don\'t exist agents' do
      result = described_class.available_agents

      expect(result).to be_empty
    end
  end

  describe '#available_items' do
    context 'when caliber is 38' do
      it 'counts available guns when pass gun type' do
        allow(Gun).to receive(:available) { 2 }

        result = described_class.available_items(:gun, '38')

        expected_result = [0, 1, 2]

        expect(result).to eq(expected_result)
      end
    end

    context 'when caliber is 12' do
      it 'counts available guns when pass gun type' do
        allow(Gun).to receive(:available) { 2 }

        result = described_class.available_items(:gun, '12')

       expected_result = [0, 1, 2]

        expect(result).to eq(expected_result)
      end
    end
  end
end
