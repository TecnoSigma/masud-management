# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tackle, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Tackle' do
      tackle = Tackle.new

      expect(tackle).to respond_to(:status)
    end

    it 'validates relationship (N:1) between Agent and Tackle' do
      tackle = Tackle.new

      expect(tackle).to respond_to(:agent)
    end
  end

  describe 'validates presence' do
    it 'no validates when no pass serial number' do
      tackle = FactoryBot.build(:tackle, serial_number: nil)

      expect(tackle).to be_invalid
    end

    it 'no validates when no pass situation' do
      tackle = FactoryBot.build(:tackle, situation: nil)

      expect(tackle).to be_invalid
    end
  end

  describe 'validates uniqueness' do
    it 'no validates when serial number is duplicated' do
      serial_number = '123456'

      FactoryBot.create(:tackle, serial_number: serial_number)
      tackle = FactoryBot.build(:tackle, serial_number: serial_number)

      expect(tackle).to be_invalid
    end
  end

  describe '.statuses' do
    it 'returns tackle status list' do
      activated_status = FactoryBot.create(:status, name: 'ativo')
      deactivated_status = FactoryBot.create(:status, name: 'desativado')

      result = Tackle.statuses

      expect(result).to eq([activated_status, deactivated_status])
    end
  end

  describe '.situations' do
    it 'returns tackle situation list' do
      regular_status = FactoryBot.create(:status, name: 'regular')
      irregular_status = FactoryBot.create(:status, name: 'irregular')

      result = Tackle.situations

      expect(result).to eq([regular_status, irregular_status])
    end
  end

  it 'returns allowed types list' do
    result = described_class::ALLOWED_TYPES

    expected_result = { waistcoat: 'Colete', radio: 'Rádio' }

    expect(result).to eq(expected_result)
  end

  describe '#in_mission?' do
    it 'returns \'true\' when tackle is in mission' do
      employee = FactoryBot.create(:employee, :agent)
      tackle = FactoryBot.create(:tackle, :radio, employee_id: employee.id)

      result = tackle.in_mission?

      expect(result).to eq(true)
    end

    it 'returns \'false\' when tackle isn\'t in mission' do
      tackle = FactoryBot.create(:tackle, :radio, employee_id: nil)

      result = tackle.in_mission?

      expect(result).to eq(false)
    end
  end
end
