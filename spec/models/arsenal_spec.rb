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
end
