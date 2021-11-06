# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MissionsHelper, type: :helper do
  include ApplicationHelper

  describe '#radios' do
    it 'returns radios description when exist radios' do
      tackle = FactoryBot.create(:tackle, :radio)
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)
      agent.tackles = [tackle]
      agent.save

      result = helper.radios([agent])

      expected_result = "Nº Série #{tackle.serial_number}"

      expect(result).to eq(expected_result)
    end

    it 'returns empty string when when doesn\'t exist radios' do
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      result = helper.radios([agent])

      expect(result).to eq('')
    end
  end

  describe '#waistcoats' do
    it 'returns waistcoats description when exist waistcoats' do
      tackle = FactoryBot.create(:tackle, :waistcoat)
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)
      agent.tackles = [tackle]
      agent.save

      result = helper.waistcoats([agent])

      expected_result = "Nº Série #{tackle.serial_number}"

      expect(result).to eq(expected_result)
    end

    it 'returns empty string when when doesn\'t exist waistcoats' do
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      result = helper.waistcoats([agent])

      expect(result).to eq('')
    end
  end

  describe '#vehicles' do
    it 'returns vehicles description when exist vehicles' do
      vehicle = FactoryBot.create(:vehicle)
      team = FactoryBot.create(:team)
      team.vehicles = [vehicle]
      team.save

      result = helper.vehicles(team)

      expected_result = "#{vehicle.name} #{vehicle.color} - #{vehicle.license_plate}"

      expect(result).to eq(expected_result)
    end

    it 'returns empty string when when doesn\'t exist vehicles' do
      team = FactoryBot.create(:team)

      result = helper.vehicles(team)

      expect(result).to eq('')
    end
  end

  describe '#fullnames_with_document' do
    it 'returns sorted agent codenames' do
      agent1 = FactoryBot.create(:employee, :agent, name: 'Zeca')
      agent2 = FactoryBot.create(:employee, :agent, name: 'Antônio')

      result = helper.fullnames_with_document([agent1, agent2])

      expected_result = "#{agent2.name} - RG: #{agent2.rg} | #{agent1.name} - RG: #{agent1.rg}"

      expect(result).to eq(expected_result)
    end
  end

  describe '#munitions' do
    it 'returns agents munitions when exist munitions' do
      quantity = 90
      caliber = '12'
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)
      FactoryBot.create(:bullet, employee: agent, quantity: quantity, caliber: caliber)

      result = helper.munitions([agent])

      expected_result = "#{quantity} projéteis calibre #{caliber}"

      expect(result).to eq(expected_result)
    end

    it 'returns empty string when doesn\'t exist munitions' do
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      result = helper.munitions([agent])

      expect(result).to eq('')
    end
  end

  describe '#gunss' do
    it 'returns guns description when exist guns' do
      caliber = '12'
      gun = FactoryBot.create(:arsenal, :gun, caliber: caliber)
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)
      agent.arsenals = [gun]
      agent.save

      result = helper.guns([agent])

      expected_result = "#{gun.kind} #{gun.caliber} - Nº Série #{gun.number}"

      expect(result).to eq(expected_result)
    end

    it 'returns empty string when doesn\'t exist guns' do
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)
      agent.save

      result = helper.guns([agent])

      expect(result).to eq('')
    end
  end
end
