# frozen_string_literal: true

module Builders
  class Mission
    include AASM

    attr_reader :team_name, :agents, :calibers12, :calibers38, :munitions12, :munitions38,
                :waistcoats, :radios, :vehicles, :order_number

    CALIBERS = { caliber12: '12', caliber38: '38' }.freeze

    private_constant :CALIBERS

    aasm do
      state :mounted_team, initial: true
      state :provided_guns
      state :provided_munitions12
      state :provided_munitions38
      state :provided_waistcoats
      state :provided_radios
      state :provided_vehicles
      state :updated_service
      state :created_new_mission
      state :finished

      event :mount_team do
        transitions from: :mounted_team,
                    to: :provided_guns,
                    if: :mount_team!
      end

      event :provide_guns do
        transitions from: :provided_guns,
                    to: :provided_munitions12,
                    if: :provide_guns!
      end

      event :provide_munitions12 do
        transitions from: :provided_munitions12,
                    to: :provided_munitions38,
                    if: :provide_munitions12!
      end

      event :provide_munitions38 do
        transitions from: :provided_munitions38,
                    to: :provided_waistcoats,
                    if: :provide_munitions38!
      end

      event :provide_waistcoats do
        transitions from: :provided_waistcoats,
                    to: :provided_radios,
                    if: :provide_waistcoats!
      end

      event :provide_radios do
        transitions from: :provided_radios,
                    to: :provided_vehicles,
                    if: :provide_radios!
      end

      event :provide_vehicles do
        transitions from: :provided_vehicles,
                    to: :updated_service,
                    if: :provide_vehicles!
      end

      event :update_service do
        transitions from: :updated_service,
                    to: :created_new_mission,
                    if: :update_service!
      end

      event :create_new_mission do
        transitions from: :created_new_mission,
                    to: :finished,
                    if: :create_new_mission!
      end
    end

    def initialize(mission_info)
      @team_name = mission_info['team']['team_name']
      @agents = mission_info['team']['agents']
      @calibers12 = mission_info['descriptive_items']['calibers12']
      @calibers38 = mission_info['descriptive_items']['calibers38']
      @munitions12 = mission_info['descriptive_items']['munitions12']
      @munitions38 = mission_info['descriptive_items']['munitions38']
      @waistcoats = mission_info['descriptive_items']['waistcoats']
      @radios = mission_info['descriptive_items']['radios']
      @vehicles = mission_info['descriptive_items']['vehicles']
      @order_number = mission_info['order_number']
    end

    def mount!
      execute_actions!
    end

    private

    def execute_actions!
      mount_team          if mounted_team?
      provide_guns        if provided_guns?
      provide_munitions12 if provided_munitions12?
      provide_munitions38 if provided_munitions38?
      provide_waistcoats  if provided_waistcoats?
      provide_radios      if provided_radios?
      provide_vehicles    if provided_vehicles?
      update_service      if updated_service?
      create_new_mission  if created_new_mission?
    end

    def mount_team!
      agents.split(' | ').each do |codename|
        team.agents << Agent.find_by_codename(codename)
        team.save!
      end

      team.agents.any?
    end

    def provide_guns!
      return true unless guns_serial_numbers_list

      guns_list.each do |gun|
        agent = agents_list.min_by { |employee| employee.arsenals.where(type: 'Gun').count }

        gun.update!(employee: agent)
      end

      !(guns_list.any? { |gun| gun.employee.nil? })
    end

    def provide_munitions12!
      return true unless calibers12.present?

      provide_munitions!(CALIBERS[:caliber12], munitions12)
    end

    def provide_munitions38!
      return true unless calibers38.present?

      provide_munitions!(CALIBERS[:caliber38], munitions38)
    end

    def provide_waistcoats!
      return true unless waistcoats_serial_numbers_list

      waistcoats_list.each do |waistcoat|
        agent = agents_list
                .min_by { |employee| employee.tackles.where(type: 'Waistcoat').count }

        waistcoat.update!(employee: agent)
      end

      !(waistcoats_list.any? { |waistcoat| waistcoat.employee.nil? })
    end

    def provide_radios!
      return true unless radios_serial_numbers_list

      radios_list.each do |radio|
        agent = agents_list
                .min_by { |employee| employee.tackles.where(type: 'Radio').count }

        radio.update!(employee: agent)
      end

      !(radios_list.any? { |radio| radio.employee.nil? })
    end

    def provide_vehicles!
      vehicles_license_plates_list.each do |licence_plate|
        team.vehicles << Vehicle.find_by_license_plate(licence_plate)

        team.save!
      end

      team.vehicles.any?
    end

    def update_service!
      scheduled = Order.find_by_order_number(order_number)

      scheduled.becomes(EscortService)
      scheduled.type = 'EscortService'
      scheduled.save!

      confirmed = Order.find_by_order_number(order_number)
      confirmed.update!(status: Status.find_by_name('confirmado'))
    end

    def create_new_mission!
      mission = ::Mission.new(
        team: team,
        escort_service: EscortService.find_by_order_number(order_number),
        status: Status.find_by_name('confirmado')
      )

      mission.save!
    end

    def agents_list
      @agents_list ||= agents.split(' | ').inject([]) do |list, codename|
        list << Agent.find_by_codename(codename)
      end
    end

    def guns_list
      @guns_list ||= guns_serial_numbers_list.inject([]) do |list, serial_number|
        list << Gun.find_by_number(serial_number)
      end
    end

    def guns_serial_numbers_list
      calibers12.gsub('Nº ', '').split(' | ') + calibers38.gsub('Nº ', '').split(' | ')
    end

    def waistcoats_list
      @waistcoats_list ||= waistcoats_serial_numbers_list.inject([]) do |list, serial_number|
        list << Waistcoat.find_by_serial_number(serial_number)
      end
    end

    def waistcoats_serial_numbers_list
      waistcoats.gsub('Nº Série ', '').split(' | ')
    end

    def radios_list
      @radios_list ||= radios_serial_numbers_list.inject([]) do |list, serial_number|
        list << Radio.find_by_serial_number(serial_number)
      end
    end

    def radios_serial_numbers_list
      radios.gsub('Nº Série ', '').split(' | ')
    end

    def vehicles_license_plates_list
      vehicles.split(' | ').map { |vehicle| vehicle.split(' - ').last }
    end

    def team
      @team ||= Team.find_by_name(team_name)
    end

    def munitions_quantity(caliber, type)
      type.gsub(' projéteis', '').to_i / calibers_list(caliber).count
    end

    def calibers_list(caliber)
      agents_list
        .map { |agent| agent.arsenals.map(&:caliber).include?(caliber) }
        .reject { |element| element == false }
    end

    def provide_munitions!(caliber, type)
      agents_list.each do |agent|
        if agent.arsenals.map(&:caliber).include?(caliber)
          Bullet
            .create(quantity: munitions_quantity(caliber, type), caliber: caliber, employee: agent)
        end
      end

      agents_list.map(&:bullets)
                 .flatten
                 .map { |bullet| bullet.caliber == caliber }
                 .include?(true)
    end
  end
end
