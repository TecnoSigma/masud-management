# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MissionsHelper, type: :helper do
  include ApplicationHelper

  describe '#mission_fullnames_with_document' do
    context 'when mission is finished' do
      xit 'returns agents fullnames with document' do
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

        mission = FactoryBot.create(:mission,
                                    team: team,
                                    escort_service: escort_service,
                                    finished_at: DateTime.now)

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
                                            agents: [agent.codename],
                                            items: items)

        agent_data = "#{agent.name} - RG: #{agent.rg}"

        allow(MissionsHistoryPresenter).to receive(:fullnames_with_document) { agent_data }

        result = helper.fullnames_with_document(mission)

        expect(result).to eq(agent_data)
      end
    end
  end
end
