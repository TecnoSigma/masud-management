# frozen_string_literal: true

module Builders
  class FinishMission
    include AASM

    attr_reader :mission

    aasm do
      state :created_mission_history, initial: true
      state :updated_agents_last_mission
      state :dismembered_team
      state :updated_munitions_stock
      state :returned_arsenal
      state :returned_tackles
      state :returned_vehicles
      state :updated_mission_status
      state :added_finish_timestamp
      state :created_mission_history
      state :finished

      event :create_mission_history do
        transitions from: :created_mission_history,
                    to: :updated_agents_last_mission,
                    if: :create_mission_history!
      end

      event :update_agents_last_mission do
        transitions from: :updated_agents_last_mission,
                    to: :dismembered_team,
                    if: :update_agents_last_mission!
      end

      event :dismember_team do
        transitions from: :dismembered_team,
                    to: :updated_munitions_stock,
                    if: :dismember_team!
      end

      event :update_munitions_stock do
        transitions from: :updated_munitions_stock,
                    to: :returned_arsenal,
                    if: :update_munitions_stock!
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
                    to: :updated_mission_status,
                    if: :return_vehicles!
      end

      event :update_mission_status do
        transitions from: :updated_mission_status,
                    to: :added_finish_timestamp,
                    if: :update_mission_status!
      end

      event :add_finish_timestamp do
        transitions from: :added_finish_timestamp,
                    to: :finished,
                    if: :add_finish_timestamp!
      end
    end

    def initialize(mission)
      @mission = mission
    end

    def dismount!
      execute_actions!
    end

    private

    def execute_actions!
      create_mission_history       if created_mission_history?
      update_agents_last_mission   if updated_agents_last_mission?
      dismember_team               if dismembered_team?
      update_munitions_stock       if updated_munitions_stock?
      return_arsenal               if returned_arsenal?
      return_tackles               if returned_tackles?
      return_vehicles              if returned_vehicles?
      update_mission_status        if updated_mission_status?
      add_finish_timestamp         if added_finish_timestamp?
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

    def dismember_team!
      team = mission.team
      team.agents = []
      team.save

      team.agents.empty?
    end

    def update_munitions_stock!
      # munitions = mission
      #  .team
      #  .agents
      #  .map { |agent| agent.arsenals }
      #  .flatten
      #  .map { |arsenal| arsenal if arsenal.instance_of?(Munition) }
      #  .compact
      #  .map { |munition| { kind: munition.kind, quantity: munition.quantity } }

      true
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

    def update_mission_status!
      mission.update!(status: Status.find_by_name('finalizada'))
    end

    def add_finish_timestamp!
      mission.update!(finished_at: DateTime.now)
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

    def agents
      @agents ||= mission.team.agents
    end
  end
end
