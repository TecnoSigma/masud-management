# frozen_string_literal: true

module MissionsHelper
  def radios(agents)
    return '' unless agents.map(&:tackles)

    agents
      .map(&:tackles)
      .flatten
      .map { |tackle| tackle if tackle.type == 'Radio' }
      .compact
      .map { |radio| "Nº Série #{radio.serial_number}" }
      .join(' | ')
  end

  def waistcoats(agents)
    return '' unless agents.map(&:tackles)

    agents
      .map(&:tackles)
      .flatten
      .map { |tackle| tackle if tackle.type == 'Waistcoat' }
      .compact
      .map { |radio| "Nº Série #{radio.serial_number}" }
      .join(' | ')
  end

  def vehicles(team)
    return '' unless team.vehicles

    team
      .vehicles
      .map { |vehicle| "#{vehicle.name} #{vehicle.color} - #{vehicle.license_plate}" }
      .join(' | ')
  end

  def codenames(agents)
    agents
      .map(&:codename)
      .sort
      .join(' | ')
  end

  def munitions(agents)
    return '' unless agents.map(&:bullets)

    agents
      .map(&:bullets)
      .flatten
      .map { |bullet| "#{bullet.quantity} projéteis calibre #{bullet.caliber}" }
      .join(' | ')
  end

  def guns(agents)
    return '' unless agents.map(&:arsenals)

    agents
      .map(&:arsenals)
      .flatten
      .map { |gun| "#{gun.kind.titleize} #{gun.caliber} - Nº Série #{gun.number}" }
      .join(' | ')
  end
end
