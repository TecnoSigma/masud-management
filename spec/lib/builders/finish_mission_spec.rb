# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Builders::FinishMission do
  describe '#dismount!' do
    it 'dismounts mission when pass all states' do
      observation = 'Any observation'
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
      allow_any_instance_of(described_class).to receive(:return_munitions!) { true }
      allow_any_instance_of(described_class).to receive(:return_tackles!) { true }
      allow_any_instance_of(described_class).to receive(:return_vehicles!) { true }
      allow_any_instance_of(described_class).to receive(:update_mission_status!) { true }
      allow_any_instance_of(described_class).to receive(:add_finish_timestamp!) { true }
      allow_any_instance_of(described_class).to receive(:create_mission_history!) { true }
      allow_any_instance_of(described_class).to receive(:add_observation!) { true }
      allow_any_instance_of(described_class).to receive(:update_order_status!) { true }

      result = described_class.new(mission, observation).send(:dismount!)

      expect(result).to eq(true)
    end

    it 'no mounts mission when one pass fail' do
      observation = 'Any observation'
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
      allow_any_instance_of(described_class).to receive(:return_munitions!) { true }
      allow_any_instance_of(described_class).to receive(:return_tackles!) { false }
      allow_any_instance_of(described_class).to receive(:return_vehicles!) { true }
      allow_any_instance_of(described_class).to receive(:update_mission_status!) { true }
      allow_any_instance_of(described_class).to receive(:add_finish_timestamp!) { true }
      allow_any_instance_of(described_class).to receive(:create_mission_history!) { true }
      allow_any_instance_of(described_class).to receive(:add_observation!) { true }
      allow_any_instance_of(described_class).to receive(:update_order_status!) { true }

      expect do
        described_class.new(mission, observation).send(:dismount!)
      end.to raise_error(AASM::InvalidTransition)
    end
  end

  describe '#update_agents_last_mission!' do
    it 'updates agents last mission' do
      observation = 'Any observation'
      FactoryBot.create(:status, name: 'iniciada')
      employee = FactoryBot.create(:employee, :agent, last_mission: nil)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      result = described_class.new(mission, observation).send(:update_agents_last_mission!)

      expected_result = Agent.find(agent.id).last_mission.present?

      expect(result).to eq(true)
      expect(result).to eq(expected_result)
    end
  end

  describe '#dismember_team!' do
    it 'removes agents of team' do
      observation = 'Any observation'
      FactoryBot.create(:status, name: 'iniciada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      result = described_class.new(mission, observation).send(:dismember_team!)

      expected_result = team.agents.empty?

      expect(result).to eq(true)
      expect(Agent.find(agent.id).team).to be_nil
      expect(result).to eq(expected_result)
    end
  end

  describe '#return_munitions!' do
    context 'when haven\'t munitions' do
      it 'no give back munition to stock' do
        FactoryBot.create(:status, name: 'iniciada')
        observation = 'Any observation'
        employee = FactoryBot.create(:employee, :agent)
        agent = Agent.find(employee.id)

        stock_quantity = 1000
        FactoryBot.create(:munition_stock, caliber: '12', quantity: stock_quantity)

        team = FactoryBot.create(:team)
        team.agents << agent
        team.save

        FactoryBot.create(:bullet, caliber: '12', quantity: 0, employee: agent)

        gun = FactoryBot.create(:arsenal, :gun)
        agent.arsenals << gun
        agent.save

        order = FactoryBot.create(:order, :confirmed)
        escort_service = EscortService.find(order.id)

        mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

        result = described_class.new(mission, observation).send(:return_munitions!)

        result2 = MunitionStock.find_by_caliber('12').quantity
        result3 = Employee.find(agent.id).bullets

        expect(result).to eq(true)
        expect(result2).to eq(stock_quantity)
        expect(result3).to be_empty
      end
    end

    context 'when have munitions' do
      context 'with same caliber' do
        it 'give back munition to stock and clean mission bullets' do
          FactoryBot.create(:status, name: 'iniciada')
          observation = 'Any observation'
          employee1 = FactoryBot.create(:employee, :agent)
          agent1 = Agent.find(employee1.id)
          employee2 = FactoryBot.create(:employee, :agent)
          agent2 = Agent.find(employee2.id)

          stock_quantity = 1000
          FactoryBot.create(:munition_stock, caliber: '12', quantity: stock_quantity)

          team = FactoryBot.create(:team)
          team.agents << agent1
          team.agents << agent2
          team.save

          returned_quantity1 = 200
          returned_quantity2 = 50
          bullet1 = FactoryBot.create(:bullet,
                                      caliber: '12',
                                      quantity: returned_quantity1,
                                      employee: agent1)

          bullet2 = FactoryBot.create(:bullet,
                                      caliber: '12',
                                      quantity: returned_quantity2,
                                      employee: agent2)

          gun1 = FactoryBot.create(:arsenal, :gun)
          agent1.arsenals << gun1
          agent1.save

          gun2 = FactoryBot.create(:arsenal, :gun)
          agent2.arsenals << gun2
          agent2.save

          order = FactoryBot.create(:order, :confirmed)
          escort_service = EscortService.find(order.id)

          mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

          result = described_class.new(mission, observation).send(:return_munitions!)

          result2 = MunitionStock.find_by_caliber('12').quantity
          result3 = Employee.find(agent1.id).bullets
          result4 = Employee.find(agent2.id).bullets
          result5 = Bullet.where(id: bullet1.id)
          result6 = Bullet.where(id: bullet2.id)

          expected_result = stock_quantity + returned_quantity1 + returned_quantity2

          expect(result).to eq(true)
          expect(result2).to eq(expected_result)
          expect(result3).to be_empty
          expect(result4).to be_empty
          expect(result5).to be_empty
          expect(result6).to be_empty
        end
      end

      context 'with different calibers to more one agent' do
        it 'give back munition to stock and clean mission bullets' do
          FactoryBot.create(:status, name: 'iniciada')
          observation = 'Any observation'
          employee1 = FactoryBot.create(:employee, :agent)
          agent1 = Agent.find(employee1.id)
          employee2 = FactoryBot.create(:employee, :agent)
          agent2 = Agent.find(employee2.id)

          stock_quantity12 = 1000
          stock_quantity38 = 500
          FactoryBot.create(:munition_stock, caliber: '12', quantity: stock_quantity12)
          FactoryBot.create(:munition_stock, caliber: '38', quantity: stock_quantity38)

          team = FactoryBot.create(:team)
          team.agents << agent1
          team.agents << agent2
          team.save

          returned_quantity12 = 200
          returned_quantity38 = 50
          bullet1 = FactoryBot.create(:bullet,
                                      caliber: '12',
                                      quantity: returned_quantity12,
                                      employee: agent1)

          bullet2 = FactoryBot.create(:bullet,
                                      caliber: '38',
                                      quantity: returned_quantity38,
                                      employee: agent2)

          gun1 = FactoryBot.create(:arsenal, :gun)
          agent1.arsenals << gun1
          agent1.save

          gun2 = FactoryBot.create(:arsenal, :gun)
          agent2.arsenals << gun2
          agent2.save

          order = FactoryBot.create(:order, :confirmed)
          escort_service = EscortService.find(order.id)

          mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

          result = described_class.new(mission, observation).send(:return_munitions!)

          result2 = MunitionStock.find_by_caliber('12').quantity
          result3 = MunitionStock.find_by_caliber('38').quantity
          result4 = Employee.find(agent1.id).bullets
          result5 = Employee.find(agent2.id).bullets
          result6 = Bullet.where(id: bullet1.id)
          result7 = Bullet.where(id: bullet2.id)

          expected_result12 = stock_quantity12 + returned_quantity12
          expected_result38 = stock_quantity38 + returned_quantity38

          expect(result).to eq(true)
          expect(result2).to eq(expected_result12)
          expect(result3).to eq(expected_result38)
          expect(result4).to be_empty
          expect(result5).to be_empty
          expect(result6).to be_empty
          expect(result7).to be_empty
        end
      end

      context 'with different calibers to same agent' do
        it 'give back munition to stock and clean mission bullets' do
          FactoryBot.create(:status, name: 'iniciada')
          observation = 'Any observation'
          employee = FactoryBot.create(:employee, :agent)
          agent = Agent.find(employee.id)

          stock_quantity12 = 1000
          stock_quantity38 = 500
          FactoryBot.create(:munition_stock, caliber: '12', quantity: stock_quantity12)
          FactoryBot.create(:munition_stock, caliber: '38', quantity: stock_quantity38)

          team = FactoryBot.create(:team)
          team.agents << agent
          team.save

          returned_quantity12 = 200
          returned_quantity38 = 50
          bullet1 = FactoryBot.create(:bullet,
                                      caliber: '12',
                                      quantity: returned_quantity12,
                                      employee: agent)

          bullet2 = FactoryBot.create(:bullet,
                                      caliber: '38',
                                      quantity: returned_quantity38,
                                      employee: agent)

          gun1 = FactoryBot.create(:arsenal, :gun)
          agent.arsenals << gun1
          agent.save

          gun2 = FactoryBot.create(:arsenal, :gun)
          agent.arsenals << gun2
          agent.save

          order = FactoryBot.create(:order, :confirmed)
          escort_service = EscortService.find(order.id)

          mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

          result = described_class.new(mission, observation).send(:return_munitions!)

          result2 = MunitionStock.find_by_caliber('12').quantity
          result3 = MunitionStock.find_by_caliber('38').quantity
          result4 = Employee.find(agent.id).bullets
          result5 = Bullet.where(id: bullet1.id)
          result6 = Bullet.where(id: bullet2.id)

          expected_result12 = stock_quantity12 + returned_quantity12
          expected_result38 = stock_quantity38 + returned_quantity38

          expect(result).to eq(true)
          expect(result2).to eq(expected_result12)
          expect(result3).to eq(expected_result38)
          expect(result4).to be_empty
          expect(result5).to be_empty
          expect(result6).to be_empty
        end
      end
    end
  end

  describe '#return_arsenal!' do
    it 'give back arsenal' do
      FactoryBot.create(:status, name: 'iniciada')
      observation = 'Any observation'
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      gun = FactoryBot.create(:arsenal, :gun)
      agent.arsenals << gun
      agent.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      result = described_class.new(mission, observation).send(:return_arsenal!)

      result2 = Arsenal.find(gun.id).employee
      result3 = agent.arsenals

      expect(result).to eq(true)
      expect(result2).to be_nil
      expect(result3).to be_empty
    end
  end

  describe '#return_tackles!' do
    it 'give back tackles' do
      FactoryBot.create(:status, name: 'iniciada')
      observation = 'Any observation'
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

      result = described_class.new(mission, observation).send(:return_tackles!)

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
      observation = 'Any observation'
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

      result = described_class.new(mission, observation).send(:return_vehicles!)

      result2 = Vehicle.find(vehicle.id).team
      result3 = team.vehicles

      expect(result).to eq(true)
      expect(result2).to be_nil
      expect(result3).to be_empty
    end
  end

  describe '#update_mission_status!' do
    it 'updates mission status to \'finalizada\'' do
      started_status = FactoryBot.create(:status, name: 'iniciada')
      finished_status = FactoryBot.create(:status, name: 'finalizada')

      observation = 'Any observation'
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

      result = described_class.new(mission, observation).send(:update_mission_status!)

      result2 = mission.status.name

      expect(result).to eq(true)
      expect(result2).to eq(finished_status.name)
    end
  end

  describe '#add_finish_timestamp!' do
    it 'adds finish timestamp in mission' do
      FactoryBot.create(:status, name: 'iniciada')
      observation = 'Any observation'
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

      result = described_class.new(mission, observation).send(:add_finish_timestamp!)

      result2 = mission.finished_at

      expect(result).to eq(true)
      expect(result2).to be_present
    end
  end

  describe '#create_mission_history!' do
    it 'creates mission history' do
      FactoryBot.create(:status, name: 'iniciada')
      observation = 'Any observation'
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      radio = FactoryBot.create(:tackle, :radio)
      waistcoat = FactoryBot.create(:tackle, :waistcoat)

      gun = FactoryBot.create(:arsenal, :gun)

      agent.arsenals << gun
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
        "Vehicle - #{vehicle.license_plate}"
      ]

      mission = FactoryBot.create(:mission, team: team, escort_service: escort_service)

      result = described_class.new(mission, observation).send(:create_mission_history!)

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

  describe '#add_observation!' do
    it 'adds finished mission observation' do
      FactoryBot.create(:status, name: 'iniciada')
      observation = 'Any observation'
      employee = FactoryBot.create(:employee, :agent, last_mission: nil)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      order = FactoryBot.create(:order, :confirmed)
      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission,
                                  team: team,
                                  escort_service: escort_service,
                                  observation: nil)

      result1 = described_class.new(mission, observation).send(:add_observation!)
      result2 = mission.observation

      expect(result1).to eq(true)
      expect(result2).to eq(observation)
    end
  end

  describe '#update_order_status!' do
    it 'updates order status to \'finalizada\'' do
      started_status = FactoryBot.create(:status, name: 'iniciada')
      finished_status = FactoryBot.create(:status, name: 'finalizada')

      observation = 'Any observation'
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

      result = described_class.new(mission, observation).send(:update_order_status!)

      result2 = Order.find_by_order_number(escort_service.order_number).status.name

      expect(result).to eq(true)
      expect(result2).to eq(finished_status.name)
    end
  end
end
