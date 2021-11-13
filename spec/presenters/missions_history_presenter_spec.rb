# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MissionsHistoryPresenter do
  describe '.radios' do
    it 'returns radios description when exist radios' do
      FactoryBot.create(:status, name: 'finalizada')
      employee = FactoryBot.create(:employee, :agent)
      agent1 = Agent.find(employee.id)
      agent2 = Agent.find(employee.id)

      vehicle = FactoryBot.create(:vehicle)
      gun1 = FactoryBot.create(:arsenal, :gun)
      gun2 = FactoryBot.create(:arsenal, :gun)
      radio = FactoryBot.create(:tackle, :radio)
      waistcoat1 = FactoryBot.create(:tackle, :waistcoat)
      waistcoat2 = FactoryBot.create(:tackle, :waistcoat)

      team = FactoryBot.create(:team)

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      agents = [agent1.codename, agent2.codename]

      items = ["Waistcoat - #{waistcoat1.serial_number}",
               "Radio - #{radio.serial_number}",
               "Waistcoat - #{waistcoat2.serial_number}",
               "Gun - #{gun1.number}",
               "Gun - #{gun2.number}",
               "Vehicle -#{vehicle.license_plate}"]

      mission_history = FactoryBot.create(:mission_history,
                                          mission: mission,
                                          agents: agents,
                                          items: items)

      result = described_class.radios(mission_history)

      expected_result = "Nº Série #{radio.serial_number}"

      expect(result).to eq(expected_result)
    end

    it 'returns empty string when when doesn\'t exist radios' do
      FactoryBot.create(:status, name: 'finalizada')
      employee = FactoryBot.create(:employee, :agent)
      agent1 = Agent.find(employee.id)
      agent2 = Agent.find(employee.id)

      vehicle = FactoryBot.create(:vehicle)
      gun1 = FactoryBot.create(:arsenal, :gun)
      gun2 = FactoryBot.create(:arsenal, :gun)
      waistcoat1 = FactoryBot.create(:tackle, :waistcoat)
      waistcoat2 = FactoryBot.create(:tackle, :waistcoat)

      team = FactoryBot.create(:team)

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      agents = [agent1.codename, agent2.codename]

      items = ["Waistcoat - #{waistcoat1.serial_number}",
               "Waistcoat - #{waistcoat2.serial_number}",
               "Gun - #{gun1.number}",
               "Gun - #{gun2.number}",
               "Vehicle -#{vehicle.license_plate}"]

      mission_history = FactoryBot.create(:mission_history,
                                          mission: mission,
                                          agents: agents,
                                          items: items)

      result = described_class.radios(mission_history)

      expect(result).to eq('')
    end
  end

  describe '.waistcoats' do
    it 'returns waistcoats description when exist waistcoats' do
      FactoryBot.create(:status, name: 'finalizada')
      employee = FactoryBot.create(:employee, :agent)
      agent1 = Agent.find(employee.id)
      agent2 = Agent.find(employee.id)

      vehicle = FactoryBot.create(:vehicle)
      gun1 = FactoryBot.create(:arsenal, :gun)
      gun2 = FactoryBot.create(:arsenal, :gun)
      radio = FactoryBot.create(:tackle, :radio)
      waistcoat1 = FactoryBot.create(:tackle, :waistcoat)
      waistcoat2 = FactoryBot.create(:tackle, :waistcoat)

      team = FactoryBot.create(:team)

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      agents = [agent1.codename, agent2.codename]

      items = ["Waistcoat - #{waistcoat1.serial_number}",
               "Radio - #{radio.serial_number}",
               "Waistcoat - #{waistcoat2.serial_number}",
               "Gun - #{gun1.number}",
               "Gun - #{gun2.number}",
               "Vehicle -#{vehicle.license_plate}"]

      mission_history = FactoryBot.create(:mission_history,
                                          mission: mission,
                                          agents: agents,
                                          items: items)

      result = described_class.waistcoats(mission_history)

      expected_result = "Nº Série #{waistcoat1.serial_number} | " \
                        "Nº Série #{waistcoat2.serial_number}"

      expect(result).to eq(expected_result)
    end

    it 'returns empty string when when doesn\'t exist waistcoats' do
      FactoryBot.create(:status, name: 'finalizada')
      employee = FactoryBot.create(:employee, :agent)
      agent1 = Agent.find(employee.id)
      agent2 = Agent.find(employee.id)

      vehicle = FactoryBot.create(:vehicle)
      gun1 = FactoryBot.create(:arsenal, :gun)
      gun2 = FactoryBot.create(:arsenal, :gun)
      radio = FactoryBot.create(:tackle, :radio)

      team = FactoryBot.create(:team)

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      agents = [agent1.codename, agent2.codename]

      items = ["Radio - #{radio.serial_number}",
               "Gun - #{gun1.number}",
               "Gun - #{gun2.number}",
               "Vehicle -#{vehicle.license_plate}"]

      mission_history = FactoryBot.create(:mission_history,
                                          mission: mission,
                                          agents: agents,
                                          items: items)

      result = described_class.waistcoats(mission_history)

      expect(result).to eq('')
    end
  end

  describe '.vehicles' do
    it 'returns vehicles description when exist vehicles' do
      FactoryBot.create(:status, name: 'finalizada')
      employee = FactoryBot.create(:employee, :agent)
      agent1 = Agent.find(employee.id)
      agent2 = Agent.find(employee.id)

      vehicle = FactoryBot.create(:vehicle)
      gun1 = FactoryBot.create(:arsenal, :gun)
      gun2 = FactoryBot.create(:arsenal, :gun)
      radio = FactoryBot.create(:tackle, :radio)
      waistcoat1 = FactoryBot.create(:tackle, :waistcoat)
      waistcoat2 = FactoryBot.create(:tackle, :waistcoat)

      team = FactoryBot.create(:team)

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      agents = [agent1.codename, agent2.codename]

      items = ["Waistcoat - #{waistcoat1.serial_number}",
               "Radio - #{radio.serial_number}",
               "Waistcoat - #{waistcoat2.serial_number}",
               "Gun - #{gun1.number}",
               "Gun - #{gun2.number}",
               "Vehicle - #{vehicle.license_plate}"]

      mission_history = FactoryBot.create(:mission_history,
                                          mission: mission,
                                          agents: agents,
                                          items: items)

      result = described_class.vehicles(mission_history)

      expected_result = "#{vehicle.name} #{vehicle.color} - #{vehicle.license_plate}"

      expect(result).to eq(expected_result)
    end

    it 'returns empty string when when doesn\'t exist vehicles' do
      FactoryBot.create(:status, name: 'finalizada')
      employee = FactoryBot.create(:employee, :agent)
      agent1 = Agent.find(employee.id)
      agent2 = Agent.find(employee.id)

      gun1 = FactoryBot.create(:arsenal, :gun)
      gun2 = FactoryBot.create(:arsenal, :gun)
      radio = FactoryBot.create(:tackle, :radio)
      waistcoat1 = FactoryBot.create(:tackle, :waistcoat)
      waistcoat2 = FactoryBot.create(:tackle, :waistcoat)

      team = FactoryBot.create(:team)

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      agents = [agent1.codename, agent2.codename]

      items = ["Waistcoat - #{waistcoat1.serial_number}",
               "Radio - #{radio.serial_number}",
               "Waistcoat - #{waistcoat2.serial_number}",
               "Gun - #{gun1.number}",
               "Gun - #{gun2.number}"]

      mission_history = FactoryBot.create(:mission_history,
                                          mission: mission,
                                          agents: agents,
                                          items: items)

      result = described_class.vehicles(mission_history)

      expect(result).to eq('')
    end
  end

  describe '.fullnames_with_document' do
    it 'returns sorted agent codenames' do
      FactoryBot.create(:status, name: 'finalizada')
      employee1 = FactoryBot.create(:employee, :agent, name: 'Zélia')
      employee2 = FactoryBot.create(:employee, :agent, name: 'Alfredo')
      agent1 = Agent.find(employee1.id)
      agent2 = Agent.find(employee2.id)

      vehicle = FactoryBot.create(:vehicle)
      gun1 = FactoryBot.create(:arsenal, :gun)
      gun2 = FactoryBot.create(:arsenal, :gun)
      radio = FactoryBot.create(:tackle, :radio)
      waistcoat1 = FactoryBot.create(:tackle, :waistcoat)
      waistcoat2 = FactoryBot.create(:tackle, :waistcoat)

      team = FactoryBot.create(:team)

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      agents = [agent1.codename, agent2.codename]

      items = ["Waistcoat - #{waistcoat1.serial_number}",
               "Radio - #{radio.serial_number}",
               "Waistcoat - #{waistcoat2.serial_number}",
               "Gun - #{gun1.number}",
               "Gun - #{gun2.number}",
               "Vehicle -#{vehicle.license_plate}"]

      mission_history = FactoryBot.create(:mission_history,
                                          mission: mission,
                                          agents: agents,
                                          items: items)

      result = described_class.fullnames_with_document(mission_history)

      expected_result = "#{agent2.name} - RG: #{agent2.rg} | #{agent1.name} - RG: #{agent1.rg}"

      expect(result).to eq(expected_result)
    end
  end

  describe '.munitions' do
    it 'returns agents munitions when exist munitions' do
      quantity = 90
      caliber = '12'

      FactoryBot.create(:status, name: 'finalizada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      vehicle = FactoryBot.create(:vehicle)
      gun1 = FactoryBot.create(:arsenal, :gun)
      gun2 = FactoryBot.create(:arsenal, :gun)
      radio = FactoryBot.create(:tackle, :radio)
      waistcoat1 = FactoryBot.create(:tackle, :waistcoat)
      waistcoat2 = FactoryBot.create(:tackle, :waistcoat)

      team = FactoryBot.create(:team)

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      FactoryBot.create(:bullet, employee: agent, quantity: quantity, caliber: caliber)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      agents = [agent.codename]

      items = ["Waistcoat - #{waistcoat1.serial_number}",
               "Radio - #{radio.serial_number}",
               "Waistcoat - #{waistcoat2.serial_number}",
               "Munition - #{quantity} projéteis calibre #{caliber}",
               "Gun - #{gun1.number}",
               "Gun - #{gun2.number}",
               "Vehicle -#{vehicle.license_plate}"]

      mission_history = FactoryBot.create(:mission_history,
                                          mission: mission,
                                          agents: agents,
                                          items: items)

      result = described_class.munitions(mission_history)

      expected_result = "#{quantity} projéteis calibre #{caliber}"

      expect(result).to eq(expected_result)
    end

    it 'returns empty string when doesn\'t exist munitions' do
      quantity = 90
      caliber = '12'

      FactoryBot.create(:status, name: 'finalizada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      vehicle = FactoryBot.create(:vehicle)
      gun1 = FactoryBot.create(:arsenal, :gun)
      gun2 = FactoryBot.create(:arsenal, :gun)
      radio = FactoryBot.create(:tackle, :radio)
      waistcoat1 = FactoryBot.create(:tackle, :waistcoat)
      waistcoat2 = FactoryBot.create(:tackle, :waistcoat)

      team = FactoryBot.create(:team)

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      FactoryBot.create(:bullet, employee: agent, quantity: quantity, caliber: caliber)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      agents = [agent.codename]

      items = ["Waistcoat - #{waistcoat1.serial_number}",
               "Radio - #{radio.serial_number}",
               "Waistcoat - #{waistcoat2.serial_number}",
               "Gun - #{gun1.number}",
               "Gun - #{gun2.number}",
               "Vehicle -#{vehicle.license_plate}"]

      mission_history = FactoryBot.create(:mission_history,
                                          mission: mission,
                                          agents: agents,
                                          items: items)

      result = described_class.munitions(mission_history)

      expect(result).to eq('')
    end
  end

  describe '.guns' do
    it 'returns guns description when exist guns' do
      FactoryBot.create(:status, name: 'finalizada')
      employee = FactoryBot.create(:employee, :agent)
      agent1 = Agent.find(employee.id)
      agent2 = Agent.find(employee.id)

      vehicle = FactoryBot.create(:vehicle)
      gun1 = FactoryBot.create(:arsenal, :gun)
      gun2 = FactoryBot.create(:arsenal, :gun)
      radio = FactoryBot.create(:tackle, :radio)
      waistcoat1 = FactoryBot.create(:tackle, :waistcoat)
      waistcoat2 = FactoryBot.create(:tackle, :waistcoat)

      team = FactoryBot.create(:team)

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      agents = [agent1.codename, agent2.codename]

      items = ["Waistcoat - #{waistcoat1.serial_number}",
               "Radio - #{radio.serial_number}",
               "Waistcoat - #{waistcoat2.serial_number}",
               "Gun - #{gun1.number}",
               "Gun - #{gun2.number}",
               "Vehicle -#{vehicle.license_plate}"]

      mission_history = FactoryBot.create(:mission_history,
                                          mission: mission,
                                          agents: agents,
                                          items: items)

      result = described_class.guns(mission_history)

      expected_result = "#{gun1.kind} #{gun1.caliber} - Nº Série #{gun1.number} | " \
                        "#{gun2.kind} #{gun2.caliber} - Nº Série #{gun2.number}"

      expect(result).to eq(expected_result)
    end

    it 'returns empty string when doesn\'t exist guns' do
      FactoryBot.create(:status, name: 'finalizada')
      employee = FactoryBot.create(:employee, :agent)
      agent1 = Agent.find(employee.id)
      agent2 = Agent.find(employee.id)

      vehicle = FactoryBot.create(:vehicle)
      radio = FactoryBot.create(:tackle, :radio)
      waistcoat1 = FactoryBot.create(:tackle, :waistcoat)
      waistcoat2 = FactoryBot.create(:tackle, :waistcoat)

      team = FactoryBot.create(:team)

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      agents = [agent1.codename, agent2.codename]

      items = ["Waistcoat - #{waistcoat1.serial_number}",
               "Radio - #{radio.serial_number}",
               "Waistcoat - #{waistcoat2.serial_number}",
               "Vehicle -#{vehicle.license_plate}"]

      mission_history = FactoryBot.create(:mission_history,
                                          mission: mission,
                                          agents: agents,
                                          items: items)

      result = described_class.guns(mission_history)

      expect(result).to eq('')
    end
  end
end
