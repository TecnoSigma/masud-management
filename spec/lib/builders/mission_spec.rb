# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Builders::Mission do
  describe '#mount!' do
    it 'mounts mission when pass all states' do
      mission_info = { 'team' => { 'team_name' => 'Charlie', 'agents' => 'Coelho | Paz' },
                       'descriptive_items' =>
          { 'calibers12' => 'Nº E5189308 | Nº G06375711',
            'calibers38' => 'Nº UH902995 | Nº WH146314',
            'munitions12' => '140 projéteis',
            'munitions38' => '50 projéteis',
            'waistcoats' => 'Nº Série 160122345 | Nº Série 64151537',
            'radios' => 'Nº Série 64',
            'vehicles' => 'Moby Branco - FZL 9E48' },
                       'order_number' => '20211029223838' }

      allow_any_instance_of(described_class).to receive(:mount_team!) { true }
      allow_any_instance_of(described_class).to receive(:provide_guns!) { true }
      allow_any_instance_of(described_class).to receive(:provide_munitions12!) { true }
      allow_any_instance_of(described_class).to receive(:provide_munitions38!) { true }
      allow_any_instance_of(described_class).to receive(:provide_waistcoats!) { true }
      allow_any_instance_of(described_class).to receive(:provide_radios!) { true }
      allow_any_instance_of(described_class).to receive(:provide_vehicles!) { true }
      allow_any_instance_of(described_class).to receive(:update_service!) { true }
      allow_any_instance_of(described_class).to receive(:create_new_mission!) { true }

      result = described_class.new(mission_info).send(:mount!)

      expect(result).to eq(true)
    end

    it 'no mounts mission when one pass fail' do
      mission_info = { 'team' => { 'team_name' => 'Charlie', 'agents' => 'Coelho | Paz' },
                       'descriptive_items' =>
          { 'calibers12' => 'Nº E5189308 | Nº G06375711',
            'calibers38' => 'Nº UH902995 | Nº WH146314',
            'munitions12' => '140 projéteis',
            'munitions38' => '50 projéteis',
            'waistcoats' => 'Nº Série 160122345 | Nº Série 64151537',
            'radios' => 'Nº Série 64',
            'vehicles' => 'Moby Branco - FZL 9E48' },
                       'order_number' => '20211029223838' }

      allow_any_instance_of(described_class).to receive(:mount_team!) { true }
      allow_any_instance_of(described_class).to receive(:provide_guns!) { true }
      allow_any_instance_of(described_class).to receive(:provide_munitions12!) { true }
      allow_any_instance_of(described_class).to receive(:provide_munitions38!) { true }
      allow_any_instance_of(described_class).to receive(:provide_waistcoats!) { false }
      allow_any_instance_of(described_class).to receive(:provide_radios!) { true }
      allow_any_instance_of(described_class).to receive(:provide_vehicles!) { true }
      allow_any_instance_of(described_class).to receive(:update_service!) { true }
      allow_any_instance_of(described_class).to receive(:create_new_mission!) { true }

      expect do
        described_class.new(mission_info).send(:mount!)
      end.to raise_error(AASM::InvalidTransition)
    end
  end

  describe '#mount_team!' do
    it 'mounts team with agents' do
      codename1 = 'Coelho'
      codename2 = 'Paz'
      team_name = 'Charlie'
      mission_info = { 'team' => { 'team_name' => team_name, 'agents' => "#{codename1} | #{codename2}" },
                       'descriptive_items' =>
          { 'calibers12' => 'Nº E5189308 | Nº G06375711',
            'calibers38' => 'Nº UH902995 | Nº WH146314',
            'munitions12' => '140 projéteis',
            'munitions38' => '50 projéteis',
            'waistcoats' => 'Nº Série 160122345 | Nº Série 64151537',
            'radios' => 'Nº Série 64',
            'vehicles' => 'Moby Branco - FZL 9E48' },
                       'order_number' => '20211029223838' }

      agent1 = FactoryBot.create(:employee, :agent, codename: codename1)
      agent2 = FactoryBot.create(:employee, :agent, codename: codename2)
      team = FactoryBot.create(:team, name: team_name)

      result1 = described_class.new(mission_info).send(:mount_team!)
      result2 = Team.find(team.id).agents.sort

      expected_result = [Agent.find(agent1.id), Agent.find(agent2.id)]

      expect(result1).to eq(true)
      expect(result2).to eq(expected_result)
    end
  end

  describe '#provide_guns!' do
    it 'provides guns to agents' do
      codename1 = 'Coelho'
      codename2 = 'Paz'
      serial_number_gun1 = 'E5189308'
      serial_number_gun2 = 'G06375711'
      serial_number_gun3 = 'UH902995'
      serial_number_gun4 = 'WH146314'
      mission_info = { 'team' => { 'team_name' => 'Alpha', 'agents' => "#{codename1} | #{codename2}" },
                       'descriptive_items' =>
          { 'calibers12' => "Nº #{serial_number_gun1} | Nº #{serial_number_gun2}",
            'calibers38' => "Nº #{serial_number_gun3} | Nº #{serial_number_gun4}",
            'munitions12' => '140 projéteis',
            'munitions38' => '50 projéteis',
            'waistcoats' => 'Nº Série 160122345 | Nº Série 64151537',
            'radios' => 'Nº Série 64',
            'vehicles' => 'Moby Branco - FZL 9E48' },
                       'order_number' => '20211029223838' }

      FactoryBot.create(:employee, :agent, codename: codename1)
      FactoryBot.create(:employee, :agent, codename: codename2)
      FactoryBot.create(:arsenal, :gun, number: serial_number_gun1)
      FactoryBot.create(:arsenal, :gun, number: serial_number_gun2)
      FactoryBot.create(:arsenal, :gun, number: serial_number_gun3)
      FactoryBot.create(:arsenal, :gun, number: serial_number_gun4)

      result1 = described_class.new(mission_info).send(:provide_guns!)

      result2 = Gun.find_by_number(serial_number_gun1).employee.present?
      result3 = Gun.find_by_number(serial_number_gun2).employee.present?
      result4 = Gun.find_by_number(serial_number_gun3).employee.present?
      result5 = Gun.find_by_number(serial_number_gun4).employee.present?

      expect(result1).to eq(true)
      expect(result2).to eq(true)
      expect(result3).to eq(true)
      expect(result4).to eq(true)
      expect(result5).to eq(true)
    end
  end

  describe '#provide_munitions12!' do
    context 'when the agents haven\'t guns' do
      it 'no provides munitions' do
        codename = 'Coelho'
        mission_info = { 'team' => { 'team_name' => 'Alpha', 'agents' => codename.to_s },
                         'descriptive_items' =>
            { 'calibers12' => '',
              'calibers38' => '',
              'munitions12' => '0 projéteis',
              'munitions38' => '0 projéteis',
              'waistcoats' => 'Nº Série 64151537',
              'radios' => 'Nº Série 64',
              'vehicles' => 'Moby Branco - FZL 9E48' },
                         'order_number' => '20211029223838' }

        FactoryBot.create(:employee, :agent, codename: codename)

        result1 = described_class.new(mission_info).send(:provide_munitions12!)

        result2 = Employee
                  .find_by_codename(codename)
                  .bullets

        expect(result1).to eq(true)
        expect(result2).to be_empty
      end
    end

    context 'when the agents have guns with differents calibers' do
      it 'provides munitions to caliber 12' do
        codename1 = 'Coelho'
        codename2 = 'Paz'
        codename3 = 'Silva'
        munitions12 = '50'
        munitions38 = '200'
        serial_number_gun1 = 'E5189308'
        serial_number_gun2 = 'G06375711'
        serial_number_gun3 = 'AQ5B$BR43'
        mission_info = { 'team' => { 'team_name' => 'Alpha',
                                     'agents' => "#{codename1} | #{codename2} | #{codename3}" },
                         'descriptive_items' =>
            { 'calibers12' => "Nº #{serial_number_gun1}",
              'calibers38' => "Nº #{serial_number_gun2} | Nº #{serial_number_gun3}",
              'munitions12' => "#{munitions12} projéteis",
              'munitions38' => "#{munitions38} projéteis",
              'waistcoats' => 'Nº Série 160122345 | Nº Série 64151537',
              'radios' => 'Nº Série 64',
              'vehicles' => 'Moby Branco - FZL 9E48' },
                         'order_number' => '20211029223838' }

        agent1 = FactoryBot.create(:employee, :agent, codename: codename1)
        agent2 = FactoryBot.create(:employee, :agent, codename: codename2)
        agent3 = FactoryBot.create(:employee, :agent, codename: codename3)
        FactoryBot.create(:arsenal,
                          :gun,
                          number: serial_number_gun1,
                          caliber: '12',
                          employee: agent1)
        FactoryBot.create(:arsenal,
                          :gun,
                          number: serial_number_gun2,
                          caliber: '38',
                          employee: agent2)
        FactoryBot.create(:arsenal,
                          :gun, number: serial_number_gun3,
                                caliber: '38',
                                employee: agent3)

        result1 = described_class.new(mission_info).send(:provide_munitions12!)

        result2 = Employee.find(agent1.id).bullets.where(caliber: '12').first.quantity
        result3 = Employee.find(agent2.id).bullets.where(caliber: '12')
        result4 = Employee.find(agent3.id).bullets.where(caliber: '12')

        expect(result1).to eq(true)
        expect(result2).to eq(munitions12.to_i)
        expect(result3).to be_empty
        expect(result4).to be_empty
      end
    end

    context 'when the agents have guns with same caliber' do
      it 'provides divided munitions of caliber 12 to agents' do
        codename1 = 'Coelho'
        codename2 = 'Paz'
        munitions12 = '140'
        serial_number_gun1 = 'E5189308'
        serial_number_gun2 = 'G06375711'
        mission_info = { 'team' => { 'team_name' => 'Alpha', 'agents' => "#{codename1} | #{codename2}" },
                         'descriptive_items' =>
            { 'calibers12' => "Nº #{serial_number_gun1} | Nº #{serial_number_gun2}",
              'calibers38' => '',
              'munitions12' => "#{munitions12} projéteis",
              'munitions38' => '0 projéteis',
              'waistcoats' => 'Nº Série 160122345 | Nº Série 64151537',
              'radios' => 'Nº Série 64',
              'vehicles' => 'Moby Branco - FZL 9E48' },
                         'order_number' => '20211029223838' }

        agent1 = FactoryBot.create(:employee, :agent, codename: codename1)
        agent2 = FactoryBot.create(:employee, :agent, codename: codename2)
        FactoryBot.create(:arsenal,
                          :gun,
                          number: serial_number_gun1,
                          caliber: '12',
                          employee: agent1)
        FactoryBot.create(:arsenal,
                          :gun,
                          number: serial_number_gun2,
                          caliber: '12',
                          employee: agent2)

        result1 = described_class.new(mission_info).send(:provide_munitions12!)

        result2 = Employee.find(agent1.id).bullets.where(caliber: '12').first.quantity
        result3 = Employee.find(agent2.id).bullets.where(caliber: '12').last.quantity

        expected_result = munitions12.to_i / Employee.count

        expect(result1).to eq(true)
        expect(result2).to eq(expected_result)
        expect(result3).to eq(expected_result)
      end
    end

    context 'when one agent have one gun' do
      it 'provides munitions to gun' do
        codename = 'Coelho'
        munitions12 = '140'
        serial_number_gun = 'E5189308'
        mission_info = { 'team' => { 'team_name' => 'Alpha', 'agents' => codename.to_s },
                         'descriptive_items' =>
            { 'calibers12' => "Nº #{serial_number_gun}",
              'calibers38' => '',
              'munitions12' => "#{munitions12} projéteis",
              'munitions38' => '0 projéteis',
              'waistcoats' => 'Nº Série 160122345',
              'radios' => 'Nº Série 64',
              'vehicles' => 'Moby Branco - FZL 9E48' },
                         'order_number' => '20211029223838' }

        agent = FactoryBot.create(:employee, :agent, codename: codename)
        FactoryBot.create(:arsenal,
                          :gun,
                          number: serial_number_gun,
                          caliber: '12',
                          employee: agent)

        result1 = described_class.new(mission_info).send(:provide_munitions12!)

        result2 = Employee.find(agent.id).bullets.where(caliber: '12').first.quantity

        expected_result = munitions12.to_i

        expect(result1).to eq(true)
        expect(result2).to eq(expected_result)
      end
    end
  end

  describe '#provide_munitions38!' do
    context 'when the agents haven\'t guns' do
      it 'no provides munitions' do
        codename = 'Coelho'
        mission_info = { 'team' => { 'team_name' => 'Alpha', 'agents' => codename.to_s },
                         'descriptive_items' =>
            { 'calibers12' => '',
              'calibers38' => '',
              'munitions12' => '0 projéteis',
              'munitions38' => '0 projéteis',
              'waistcoats' => 'Nº Série 64151537',
              'radios' => 'Nº Série 64',
              'vehicles' => 'Moby Branco - FZL 9E48' },
                         'order_number' => '20211029223838' }

        FactoryBot.create(:employee, :agent, codename: codename)

        result1 = described_class.new(mission_info).send(:provide_munitions38!)

        result2 = Employee
                  .find_by_codename(codename)
                  .bullets

        expect(result1).to eq(true)
        expect(result2).to be_empty
      end
    end

    context 'when the agents have guns with differents calibers' do
      it 'provides munitions to caliber 38' do
        codename1 = 'Coelho'
        codename2 = 'Paz'
        codename3 = 'Silva'
        munitions12 = '50'
        munitions38 = '200'
        serial_number_gun1 = 'E5189308'
        serial_number_gun2 = 'G06375711'
        serial_number_gun3 = 'AQ5B$BR43'
        mission_info = { 'team' => { 'team_name' => 'Alpha',
                                     'agents' => "#{codename1} | #{codename2} | #{codename3}" },
                         'descriptive_items' =>
            { 'calibers12' => "Nº #{serial_number_gun1} | Nº #{serial_number_gun2}",
              'calibers38' => "Nº #{serial_number_gun3}",
              'munitions12' => "#{munitions12} projéteis",
              'munitions38' => "#{munitions38} projéteis",
              'waistcoats' => 'Nº Série 160122345 | Nº Série 64151537',
              'radios' => 'Nº Série 64',
              'vehicles' => 'Moby Branco - FZL 9E48' },
                         'order_number' => '20211029223838' }

        agent1 = FactoryBot.create(:employee, :agent, codename: codename1)
        agent2 = FactoryBot.create(:employee, :agent, codename: codename2)
        agent3 = FactoryBot.create(:employee, :agent, codename: codename3)
        FactoryBot.create(:arsenal,
                          :gun,
                          number: serial_number_gun1,
                          caliber: '38',
                          employee: agent1)
        FactoryBot.create(:arsenal,
                          :gun,
                          number: serial_number_gun2,
                          caliber: '12',
                          employee: agent2)
        FactoryBot.create(:arsenal,
                          :gun, number: serial_number_gun3,
                                caliber: '12',
                                employee: agent3)

        result1 = described_class.new(mission_info).send(:provide_munitions38!)

        result2 = Employee.find(agent1.id).bullets.where(caliber: '38').first.quantity
        result3 = Employee.find(agent2.id).bullets.where(caliber: '38')
        result4 = Employee.find(agent3.id).bullets.where(caliber: '38')

        expect(result1).to eq(true)
        expect(result2).to eq(munitions38.to_i)
        expect(result3).to be_empty
        expect(result4).to be_empty
      end
    end

    context 'when the agents have guns with same caliber' do
      it 'provides divided munitions of caliber 38 to agents' do
        codename1 = 'Coelho'
        codename2 = 'Paz'
        munitions38 = '140'
        serial_number_gun1 = 'E5189308'
        serial_number_gun2 = 'G06375711'
        mission_info = { 'team' => { 'team_name' => 'Alpha', 'agents' => "#{codename1} | #{codename2}" },
                         'descriptive_items' =>
            { 'calibers12' => '',
              'calibers38' => "Nº #{serial_number_gun1} | Nº #{serial_number_gun2}",
              'munitions12' => '0 projéteis',
              'munitions38' => "#{munitions38} projéteis",
              'waistcoats' => 'Nº Série 160122345 | Nº Série 64151537',
              'radios' => 'Nº Série 64',
              'vehicles' => 'Moby Branco - FZL 9E48' },
                         'order_number' => '20211029223838' }

        agent1 = FactoryBot.create(:employee, :agent, codename: codename1)
        agent2 = FactoryBot.create(:employee, :agent, codename: codename2)
        FactoryBot.create(:arsenal,
                          :gun,
                          number: serial_number_gun1,
                          caliber: '38',
                          employee: agent1)
        FactoryBot.create(:arsenal,
                          :gun,
                          number: serial_number_gun2,
                          caliber: '38',
                          employee: agent2)

        result1 = described_class.new(mission_info).send(:provide_munitions38!)

        result2 = Employee.find(agent1.id).bullets.where(caliber: '38').first.quantity
        result3 = Employee.find(agent2.id).bullets.where(caliber: '38').last.quantity

        expected_result = munitions38.to_i / Employee.count

        expect(result1).to eq(true)
        expect(result2).to eq(expected_result)
        expect(result3).to eq(expected_result)
      end
    end

    context 'when one agent have one gun' do
      it 'provides munitions to gun' do
        codename = 'Coelho'
        munitions38 = '140'
        serial_number_gun = 'E5189308'
        mission_info = { 'team' => { 'team_name' => 'Alpha', 'agents' => codename.to_s },
                         'descriptive_items' =>
            { 'calibers12' => '',
              'calibers38' => "Nº #{serial_number_gun}",
              'munitions12' => '0 projéteis',
              'munitions38' => "#{munitions38} projéteis",
              'waistcoats' => 'Nº Série 160122345',
              'radios' => 'Nº Série 64',
              'vehicles' => 'Moby Branco - FZL 9E48' },
                         'order_number' => '20211029223838' }

        agent = FactoryBot.create(:employee, :agent, codename: codename)
        FactoryBot.create(:arsenal,
                          :gun,
                          number: serial_number_gun,
                          caliber: '38',
                          employee: agent)

        result1 = described_class.new(mission_info).send(:provide_munitions38!)

        result2 = Employee.find(agent.id).bullets.where(caliber: '38').first.quantity

        expected_result = munitions38.to_i

        expect(result1).to eq(true)
        expect(result2).to eq(expected_result)
      end
    end
  end

  describe '#provide_waistcoats!' do
    it 'provides waistcoats to agents' do
      codename1 = 'Coelho'
      codename2 = 'Paz'
      serial_number_waistcoat1 = '160122345'
      serial_number_waistcoat2 = '64151537'
      mission_info = { 'team' => { 'team_name' => 'Alpha', 'agents' => "#{codename1} | #{codename2}" },
                       'descriptive_items' =>
          { 'calibers12' => 'Nº E5189308 | Nº G06375711',
            'calibers38' => 'Nº UH902995 | Nº WH146314',
            'munitions12' => '140 projéteis',
            'munitions38' => '50 projéteis',
            'waistcoats' =>
              "Nº Série #{serial_number_waistcoat1} | Nº Série #{serial_number_waistcoat2}",
            'radios' => 'Nº Série 64',
            'vehicles' => 'Moby Branco - FZL 9E48' },
                       'order_number' => '20211029223838' }

      FactoryBot.create(:employee, :agent, codename: codename1)
      FactoryBot.create(:employee, :agent, codename: codename2)
      FactoryBot.create(:tackle, :waistcoat, serial_number: serial_number_waistcoat1)
      FactoryBot.create(:tackle, :waistcoat, serial_number: serial_number_waistcoat2)

      result1 = described_class.new(mission_info).send(:provide_waistcoats!)

      result2 = Tackle.find_by_serial_number(serial_number_waistcoat1).employee.present?
      result3 = Tackle.find_by_serial_number(serial_number_waistcoat2).employee.present?

      expect(result1).to eq(true)
      expect(result2).to eq(true)
      expect(result3).to eq(true)
    end
  end

  describe '#provide_radios!' do
    it 'provides radios to agents' do
      codename1 = 'Coelho'
      codename2 = 'Paz'
      serial_number_radio = '64'
      mission_info = { 'team' => { 'team_name' => 'Alpha', 'agents' => "#{codename1} | #{codename2}" },
                       'descriptive_items' =>
          { 'calibers12' => 'Nº E5189308 | Nº G06375711',
            'calibers38' => 'Nº UH902995 | Nº WH146314',
            'munitions12' => '140 projéteis',
            'munitions38' => '50 projéteis',
            'waistcoats' => 'Nº Série 64151537 | Nº Série 64151599',
            'radios' => "Nº Série #{serial_number_radio}",
            'vehicles' => 'Moby Branco - FZL 9E48' },
                       'order_number' => '20211029223838' }

      FactoryBot.create(:employee, :agent, codename: codename1)
      FactoryBot.create(:employee, :agent, codename: codename2)
      FactoryBot.create(:tackle, :radio, serial_number: serial_number_radio)

      result1 = described_class.new(mission_info).send(:provide_radios!)

      result2 = Tackle.find_by_serial_number(serial_number_radio).employee.present?

      expect(result1).to eq(true)
      expect(result2).to eq(true)
    end
  end

  describe '#provide_vehicles!' do
    it 'provides vehicles to team' do
      codename1 = 'Coelho'
      codename2 = 'Paz'
      license_plate1 = 'FZL 9E48'
      license_plate2 = 'ABC 9999'
      team_name = 'Alpha'
      mission_info = { 'team' => { 'team_name' => team_name, 'agents' => "#{codename1} | #{codename2}" },
                       'descriptive_items' =>
          { 'calibers12' => 'Nº E5189308 | Nº G06375711',
            'calibers38' => 'Nº UH902995 | Nº WH146314',
            'munitions12' => '140 projéteis',
            'munitions38' => '50 projéteis',
            'waistcoats' => 'Nº Série 64151537 | Nº Série 64151599',
            'radios' => 'Nº Série 64',
            'vehicles' => "Moby Branco - #{license_plate1} | Kwid Branco - #{license_plate2}" },
                       'order_number' => '20211029223838' }

      FactoryBot.create(:team, name: team_name)
      FactoryBot.create(:vehicle, license_plate: license_plate1)
      FactoryBot.create(:vehicle, license_plate: license_plate2)

      result1 = described_class.new(mission_info).send(:provide_vehicles!)

      result2 = Vehicle.find_by_license_plate(license_plate1).team.present?
      result3 = Vehicle.find_by_license_plate(license_plate2).team.present?

      expect(result1).to eq(true)
      expect(result2).to eq(true)
      expect(result3).to eq(true)
    end
  end

  describe '#update_service!' do
    it 'updates order to a service' do
      codename1 = 'Coelho'
      codename2 = 'Paz'
      order_number = '20211029223838'
      mission_info = { 'team' => { 'team_name' => 'Alpha', 'agents' => "#{codename1} | #{codename2}" },
                       'descriptive_items' =>
          { 'calibers12' => 'Nº E5189308 | Nº G06375711',
            'calibers38' => 'Nº UH902995 | Nº WH146314',
            'munitions12' => '140 projéteis',
            'munitions38' => '50 projéteis',
            'waistcoats' => 'Nº Série 64151537 | Nº Série 64151599',
            'radios' => 'Nº Série 64',
            'vehicles' => 'Moby Branco - FZL 9E48 | Kwid Branco - ABC 9999' },
                       'order_number' => order_number }

      FactoryBot.create(:status, name: 'aguardando confirmação')
      confirmed_status = FactoryBot.create(:status, name: 'confirmado')

      order = FactoryBot.create(:order, :scheduled)
      order.update!(order_number: order_number)

      result1 = described_class.new(mission_info).send(:update_service!)

      result2 = Order.find_by_order_number(order_number).type
      result3 = Order.find_by_order_number(order_number).status.name

      expect(result1).to eq(true)
      expect(result2).to eq('EscortService')
      expect(result3).to eq(confirmed_status.name)
    end
  end

  describe '#create_new_mission!' do
    it 'creates a new mission' do
      codename1 = 'Coelho'
      codename2 = 'Paz'
      team_name = 'Alpha'
      order_number = '20211029223838'
      mission_info = { 'team' => { 'team_name' => team_name,
                                   'agents' => "#{codename1} | #{codename2}" },
                       'descriptive_items' =>
          { 'calibers12' => 'Nº E5189308 | Nº G06375711',
            'calibers38' => 'Nº UH902995 | Nº WH146314',
            'munitions12' => '140 projéteis',
            'munitions38' => '50 projéteis',
            'waistcoats' => 'Nº Série 64151537 | Nº Série 64151599',
            'radios' => 'Nº Série 64',
            'vehicles' => 'Moby Branco - FZL 9E48 | Kwid Branco - ABC 9999' },
                       'order_number' => order_number }

      FactoryBot.create(:team, name: team_name)
      confirmed_status = FactoryBot.create(:status, name: 'confirmado')

      service = FactoryBot.create(:order, type: 'EscortService', status: confirmed_status)
      service.order_number = order_number
      service.save!

      result1 = described_class.new(mission_info).send(:create_new_mission!)

      result2 = Mission.first.team.present?
      result3 = Mission.first.status.name
      result4 = Mission.first.escort_service

      expect(result1).to eq(true)
      expect(result2).to eq(true)
      expect(result3).to eq(confirmed_status.name)
      expect(result4).to eq(EscortService.first)
    end
  end
end
