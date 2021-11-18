# frozen_string_literal: true

class MissionsHistoryPresenter
  def self.fullnames_with_document(mission_history)
    agents_list = mission_history
                  .agents.map do |agents|
      agents.split(' | ').map { |agent| Agent.find_by_codename(agent.split(' - RG: ').last) }
    end

    agents_list
      .flatten
      .sort_by(&:name)
      .map { |agent| "#{agent.name} - RG: #{agent.rg}" }
      .join(' | ')
  end

  def self.munitions(mission_history)
    munitions_list = mission_history.items.map do |item|
      Bullet.find_by_caliber(item.split.last) if item.start_with?('Munition')
    end

    munitions_list
      .compact
      .map { |bullet| "#{bullet.quantity} projéteis calibre #{bullet.caliber}" }
      .join(' | ')
  end

  def self.guns(mission_history)
    guns_list = mission_history.items.map do |item|
      Gun.find_by_number(item.split(' - ').last) if item.start_with?('Gun')
    end

    guns_list
      .compact
      .map { |gun| "#{gun.kind} #{gun.caliber} - Nº Série #{gun.number}" }
      .join(' | ')
  end

  def self.waistcoats(mission_history)
    waistcoats_list = mission_history.items.map do |item|
      Waistcoat.find_by_serial_number(item.split(' - ').last) if item.start_with?('Waistcoat')
    end

    waistcoats_list
      .compact
      .map { |waistcoat| "Nº Série #{waistcoat.serial_number}" if waistcoat }
      .join(' | ')
  end

  def self.vehicles(mission_history)
    vehicles_list = mission_history.items.map do |item|
      Vehicle.find_by_license_plate(item.split(' - ').last) if item.start_with?('Vehicle')
    end

    vehicles_list
      .compact
      .map { |vehicle| "#{vehicle.name} #{vehicle.color} - #{vehicle.license_plate}" if vehicle }
      .join(' | ')
  end

  def self.radios(mission_history)
    radios_list = mission_history.items.map do |item|
      Radio.find_by_serial_number(item.split(' - ').last) if item.start_with?('Radio')
    end

    radios_list
      .compact
      .map { |radio| "Nº Série #{radio.serial_number}" if radio }
      .join(' | ')
  end
end
