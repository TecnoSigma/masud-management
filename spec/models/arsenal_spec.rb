# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Arsenal, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Arsenal' do
      arsenal = Arsenal.new

      expect(arsenal).to respond_to(:status)
    end

    it 'validates relationship (N:1) between Employee and Arsenal' do
      arsenal = Arsenal.new

      expect(arsenal).to respond_to(:employee)
    end
  end

  describe '#in_mission?' do
    it 'returns \'true\' when gun is in mission' do
      employee = FactoryBot.create(:employee, :agent)
      gun = FactoryBot.create(:arsenal, :gun, employee_id: employee.id)

      result = gun.in_mission?

      expect(result).to eq(true)
    end

    it 'returns \'false\' when tackle isn\'t in mission' do
      gun = FactoryBot.create(:arsenal, :gun, employee_id: nil)

      result = gun.in_mission?

      expect(result).to eq(false)
    end
  end

  describe '.statuses' do
    it 'returns tackle status list' do
      activated_status = FactoryBot.create(:status, name: 'ativo')
      deactivated_status = FactoryBot.create(:status, name: 'desativado')

      result = Arsenal.statuses

      expect(result).to eq([activated_status, deactivated_status])
    end
  end

  describe '.situations' do
    it 'returns tackle situation list' do
      regular_status = FactoryBot.create(:status, name: 'regular')
      irregular_status = FactoryBot.create(:status, name: 'irregular')

      result = Arsenal.situations

      expect(result).to eq([regular_status, irregular_status])
    end
  end
end
