# frozen_string_literal: true

module Builders
  class FinishMission
    include AASM

    attr_reader :mission, :observation

    aasm do
      state :created_mission_history, initial: true
      state :updated_agents_last_mission
      state :returned_munitions
      state :returned_arsenal
      state :returned_tackles
      state :returned_vehicles
      state :dismembered_team
      state :updated_mission_status
      state :added_finish_timestamp
      state :added_observation
      state :updated_order_status
      state :finished

      event :create_mission_history do
        transitions from: :created_mission_history,
                    to: :updated_agents_last_mission,
                    if: :create_mission_history!
      end

      event :update_agents_last_mission do
        transitions from: :updated_agents_last_mission,
                    to: :returned_munitions,
                    if: :update_agents_last_mission!
      end

      event :return_munitions do
        transitions from: :returned_munitions,
                    to: :returned_arsenal,
                    if: :return_munitions!
      end

      event :return_arsenal do
        transitions from: :returned_arsenal,
                    to: :returned_tackles,
                    if: :return_arsenal!
      end

      event :return_tackles do
        transitions from: :returned_tackles,
                    to: :returned_vehicles,
                    if: :return_tackles!
      end

      event :return_vehicles do
        transitions from: :returned_vehicles,
                    to: :dismembered_team,
                    if: :return_vehicles!
      end

      event :dismember_team do
        transitions from: :dismembered_team,
                    to: :updated_mission_status,
                    if: :dismember_team!
      end

      event :update_mission_status do
        transitions from: :updated_mission_status,
                    to: :added_finish_timestamp,
                    if: :update_mission_status!
      end

      event :add_finish_timestamp do
        transitions from: :added_finish_timestamp,
                    to: :added_observation,
                    if: :add_finish_timestamp!
      end

      event :add_observation do
        transitions from: :added_observation,
                    to: :updated_order_status,
                    if: :add_observation!
      end

      event :update_order_status do
        transitions from: :updated_order_status,
                    to: :finished,
                    if: :update_order_status!
      end
    end

    def initialize(mission, observation)
      @mission = mission
      @observation = observation
    end

    def dismount!
      execute_actions!
    end

    private

    def execute_actions!
      create_mission_history     if created_mission_history?
      update_agents_last_mission if updated_agents_last_mission?
      return_munitions           if returned_munitions?
      return_arsenal             if returned_arsenal?
      return_tackles             if returned_tackles?
      return_vehicles            if returned_vehicles?
      dismember_team             if dismembered_team?
      update_mission_status      if updated_mission_status?
      add_finish_timestamp       if added_finish_timestamp?
      add_observation            if added_observation?
      update_order_status        if updated_order_status?
    end

    def create_mission_history!
      history = MissionHistory.new(
        team: mission.team.name,
        agents: mission.team.agents.map(&:codename),
        items: [tackles, arsenals, vehicles].flatten,
        mission: mission
      )

      history.save!
    end

    def update_agents_last_mission!
      agents.each { |agent| agent.update(last_mission: DateTime.now) }

      agents.map(&:last_mission).none?(&:nil?)
    end

    def return_munitions!
      return_bullets! && update_munitions_stock!
    end

    def return_arsenal!
      agents.each { |agent| agent.update(arsenals: []) }

      agents.map(&:arsenals).flatten.empty?
    end

    def return_tackles!
      agents.each { |agent| agent.update(tackles: []) }

      agents.map(&:tackles).flatten.empty?
    end

    def return_vehicles!
      mission.team.update(vehicles: [])

      mission.team.vehicles.empty?
    end

    def dismember_team!
      team = mission.team
      team.agents = []
      team.save

      team.agents.empty?
    end

    def update_mission_status!
      mission.update!(status: Status.find_by_name('finalizada'))
    end

    def add_finish_timestamp!
      mission.update!(finished_at: DateTime.now)
    end

    def add_observation!
      mission.update!(observation: observation)
    end

    def update_order_status!
      order_number = mission.escort_service.order_number

      order = Order.find_by_order_number(order_number)
      order.update!(status: Status.find_by_name('finalizada'))
    end

    def vehicles
      mission
        .team
        .vehicles
        .map { |vehicle| "#{vehicle.class.name} - #{vehicle.license_plate}" }
        .uniq
    end

    def tackles
      agents
        .map(&:tackles)
        .flatten
        .map { |tackle| "#{tackle.type} - #{tackle.serial_number}" }
        .uniq
    end

    def arsenals
      agents
        .map(&:arsenals)
        .flatten
        .map { |arsenal| "#{arsenal.type} - #{arsenal.number}" }
        .uniq
    end

    def return_bullets!
      @bullets = agents
                 .map(&:bullets)
                 .flatten
                 .map { |bullet| { id: bullet.id, caliber: bullet.caliber, quantity: bullet.quantity } }

      @bullets.each { |bullet| Bullet.find(bullet[:id]).delete }

      agents.reload

      agents.map(&:bullets).flatten.empty?
    end

    def update_munitions_stock!
      @bullets.inject([]) do |list, bullet|
        munition_stock = MunitionStock.find_by_caliber(bullet[:caliber])

        list << munition_stock.update!(quantity: munition_stock.quantity + bullet[:quantity])
      end
              .uniq
              .exclude?(false)
    end

    def agents
      @agents ||= mission.team.agents
    end
  end
end
