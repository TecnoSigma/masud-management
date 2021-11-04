# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Builders::FinishMission do
  describe '#dismount!' do
    it 'dismounts mission when pass all states' do
      FactoryBot.create(:status, name: 'iniciada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      allow_any_instance_of(described_class).to receive(:update_agents_last_mission!) { true }
      allow_any_instance_of(described_class).to receive(:dismember_team!) { true }
      allow_any_instance_of(described_class).to receive(:return_arsenal!) { true }
      allow_any_instance_of(described_class).to receive(:update_munitions_stock!) { true }
      allow_any_instance_of(described_class).to receive(:return_tackles!) { true }
      allow_any_instance_of(described_class).to receive(:return_vehicles!) { true }
      allow_any_instance_of(described_class).to receive(:update_mission_status!) { true }
      allow_any_instance_of(described_class).to receive(:add_finish_timestamp!) { true }
      allow_any_instance_of(described_class).to receive(:create_mission_history!) { true }

      result = described_class.new(mission).send(:dismount!)

      expect(result).to eq(true)
    end

    it 'no mounts mission when one pass fail' do
      FactoryBot.create(:status, name: 'iniciada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      allow_any_instance_of(described_class).to receive(:update_agents_last_mission!) { true }
      allow_any_instance_of(described_class).to receive(:dismember_team!) { true }
      allow_any_instance_of(described_class).to receive(:return_arsenal!) { true }
      allow_any_instance_of(described_class).to receive(:update_munitions_stock!) { true }
      allow_any_instance_of(described_class).to receive(:return_tackles!) { false }
      allow_any_instance_of(described_class).to receive(:return_vehicles!) { true }
      allow_any_instance_of(described_class).to receive(:update_mission_status!) { true }
      allow_any_instance_of(described_class).to receive(:add_finish_timestamp!) { true }
      allow_any_instance_of(described_class).to receive(:create_mission_history!) { true }

      expect do
        described_class.new(mission).send(:dismount!)
      end.to raise_error(AASM::InvalidTransition)
    end
  end

  describe '#update_agents_last_mission!' do
    it 'updates agents last mission' do
      FactoryBot.create(:status, name: 'iniciada')
      employee = FactoryBot.create(:employee, :agent, last_mission: nil)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      result = described_class.new(mission).send(:update_agents_last_mission!)

      expected_result = Agent.find(agent.id).last_mission.present?

      expect(result).to eq(true)
      expect(result).to eq(expected_result)
    end
  end

  describe '#dismember_team!' do
    it 'removes agents of team' do
      FactoryBot.create(:status, name: 'iniciada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      result = described_class.new(mission).send(:dismember_team!)

      expected_result = team.agents.empty?

      expect(result).to eq(true)
      expect(Agent.find(agent.id).team).to be_nil
      expect(result).to eq(expected_result)
    end
  end

  describe '#update_munitions_stock!' do
    xit 'updates munitions stock with the quantities that the agents give back' do
      FactoryBot.create(:status, name: 'iniciada')

      stock_quantity12 = 2000
      stock_quantity38 = 1500
      stock12 = FactoryBot.create(:munition_stock, caliber: '12', quantity: stock_quantity12)
      stock38 = FactoryBot.create(:munition_stock, caliber: '38', quantity: stock_quantity38)

      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      gun = FactoryBot.create(:arsenal, :gun)
      munition12 = FactoryBot.create(:arsenal, :munition, kind: '12')
      munition38 = FactoryBot.create(:arsenal, :munition, kind: '38')

      agent.arsenals << gun
      agent.arsenals << munition12
      agent.arsenals << munition38
      agent.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      result = described_class.new(mission).send(:update_munitions_stock!)
    end
  end

  describe '#return_arsenal!' do
    it 'give back arsenal' do
      FactoryBot.create(:status, name: 'iniciada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      gun = FactoryBot.create(:arsenal, :gun)
      munition = FactoryBot.create(:arsenal, :munition)
      agent.arsenals << gun
      agent.arsenals << munition
      agent.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      result = described_class.new(mission).send(:return_arsenal!)

      result2 = Arsenal.find(gun.id).employee
      result3 = Arsenal.find(munition.id).employee
      result4 = agent.arsenals

      expect(result).to eq(true)
      expect(result2).to be_nil
      expect(result3).to be_nil
      expect(result4).to be_empty
    end
  end

  describe '#return_tackles!' do
    it 'give back tackles' do
      FactoryBot.create(:status, name: 'iniciada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      radio = FactoryBot.create(:tackle, :radio)
      waistcoat = FactoryBot.create(:tackle, :waistcoat)
      agent.tackles << radio
      agent.tackles << waistcoat
      agent.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      result = described_class.new(mission).send(:return_tackles!)

      result2 = Tackle.find(radio.id).employee
      result3 = Tackle.find(waistcoat.id).employee
      result4 = agent.tackles

      expect(result).to eq(true)
      expect(result2).to be_nil
      expect(result3).to be_nil
      expect(result4).to be_empty
    end
  end

  describe '#return_vehicles!' do
    it 'give back vehicles' do
      FactoryBot.create(:status, name: 'iniciada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      vehicle = FactoryBot.create(:vehicle)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.vehicles << vehicle
      team.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      result = described_class.new(mission).send(:return_vehicles!)

      result2 = Vehicle.find(vehicle.id).team
      result3 = team.vehicles

      expect(result).to eq(true)
      expect(result2).to be_nil
      expect(result3).to be_empty
    end
  end

  describe '#update_mission_status!' do
    it 'updates mission status to \'terminada\'' do
      started_status = FactoryBot.create(:status, name: 'iniciada')
      finished_status = FactoryBot.create(:status, name: 'finalizada')

      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission,
                                  team: team,
                                  escort_service: escort_service,
                                  status: started_status)

      result = described_class.new(mission).send(:update_mission_status!)

      result2 = mission.status.name

      expect(result).to eq(true)
      expect(result2).to eq(finished_status.name)
    end
  end

  describe '#add_finish_timestamp!' do
    it 'adds finish timestamp in mission' do
      FactoryBot.create(:status, name: 'iniciada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission,
                                  team: team,
                                  escort_service: escort_service,
                                  finished_at: nil)

      result = described_class.new(mission).send(:add_finish_timestamp!)

      result2 = mission.finished_at

      expect(result).to eq(true)
      expect(result2).to be_present
    end
  end

  describe '#create_mission_history!' do
    it 'creates mission history' do
      FactoryBot.create(:status, name: 'iniciada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      radio = FactoryBot.create(:tackle, :radio)
      waistcoat = FactoryBot.create(:tackle, :waistcoat)

      gun = FactoryBot.create(:arsenal, :gun)
      munition = FactoryBot.create(:arsenal, :munition)

      agent.arsenals << gun
      agent.arsenals << munition
      agent.tackles << radio
      agent.tackles << waistcoat
      agent.save

      vehicle = FactoryBot.create(:vehicle)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.vehicles << vehicle
      team.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      items = [
        "Radio - #{radio.serial_number}",
        "Waistcoat - #{waistcoat.serial_number}",
        "Gun - #{gun.number}",
        "Munition - #{munition.number}",
        "Vehicle - #{vehicle.license_plate}"
      ]

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      result = described_class.new(mission).send(:create_mission_history!)

      result2 = MissionHistory.last.agents
      result3 = MissionHistory.last.items
      result4 = MissionHistory.last.team
      result5 = MissionHistory.last.mission

      expect(result).to eq(true)
      expect(result2).to eq([agent.codename])
      expect(result3).to eq(items)
      expect(result4).to eq(team.name)
      expect(result5).to eq(mission)
    end
  end
end
