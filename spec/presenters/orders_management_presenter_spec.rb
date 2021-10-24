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
    it 'counts available guns (caliber 38) when pass gun type' do
      guns_quantity = 10

      employee = FactoryBot.create(:employee, :agent)
      FactoryBot.create(:arsenal, :gun, caliber: '38', employee: employee)
      FactoryBot.create_list(:arsenal, guns_quantity, :gun, caliber: '38', employee: nil)

      result = described_class.available_items(:gun, '38')

      expected_result = (0..guns_quantity).to_a

      expect(result).to eq(expected_result)
    end

    it 'counts available guns (caliber 12) when pass gun type' do
      guns_quantity = 10

      employee = FactoryBot.create(:employee, :agent)
      FactoryBot.create(:arsenal, :gun, caliber: '12', employee: employee)
      FactoryBot.create_list(:arsenal, guns_quantity, :gun, caliber: '12', employee: nil)

      result = described_class.available_items(:gun, '12')

      expected_result = (0..guns_quantity).to_a

      expect(result).to eq(expected_result)
    end

    it 'counts available waistcoats when pass waistcoat type' do
      waistcoats_quantity = 50

      employee = FactoryBot.create(:employee, :agent)
      FactoryBot.create(:tackle, :waistcoat, employee: employee)
      FactoryBot.create_list(:tackle, waistcoats_quantity, :waistcoat, employee: nil)

      result = described_class.available_items(:waistcoat)

      expected_result = (0..waistcoats_quantity).to_a

      expect(result).to eq(expected_result)
    end

    it 'counts available radios when pass radio type' do
      radios_quantity = 2

      employee = FactoryBot.create(:employee, :agent)
      FactoryBot.create(:tackle, :radio, employee: employee)
      FactoryBot.create_list(:tackle, radios_quantity, :radio, employee: nil)

      result = described_class.available_items(:radio)

      expected_result = (0..radios_quantity).to_a

      expect(result).to eq(expected_result)
    end

    it 'counts available vehicles when pass radio type' do
      vehicles_quantity = 10

      team = FactoryBot.create(:team)
      FactoryBot.create(:vehicle, team: team)
      FactoryBot.create_list(:vehicle, vehicles_quantity, team: nil)

      result = described_class.available_items(:vehicle)

      expected_result = (0..vehicles_quantity).to_a

      expect(result).to eq(expected_result)
    end
  end
end
