# frozen_string_literal: true

module Builders
  class MissionItems
    attr_reader :calibers12,
                :calibers38,
                :munitions12,
                :munitions38,
                :waistcoats,
                :radios,
                :vehicles

    def initialize(items)
      items.each { |key, value| items[key] = value.to_i }

      @calibers12 = items['calibers_12_quantity']
      @calibers38 = items['calibers_38_quantity']
      @munitions12 = items['munitions_12_quantity']
      @munitions38 = items['munitions_38_quantity']
      @waistcoats = items['waistcoats_quantity']
      @radios = items['radios_quantity']
      @vehicles = items['vehicles_quantity']
    end

    def mount!
      { calibers12: mount_calibers12,
        calibers38: mount_calibers38,
        munitions12: mount_munitions12,
        munitions38: mount_munitions38,
        waistcoats: mount_waistcoats,
        radios: mount_radios,
        vehicles: mount_vehicles }
    end

    private

    def mount_calibers12
      item_list = Gun.where(caliber: '12').where(employee: nil).sample(calibers12).map(&:number)
      items_description(item_list, 'number')
    end

    def mount_calibers38
      item_list = Gun.where(caliber: '38').where(employee: nil).sample(calibers38).map(&:number)
      items_description(item_list, 'number')
    end

    def mount_munitions12
      bullets_description(munitions12)
    end

    def mount_munitions38
      bullets_description(munitions38)
    end

    def mount_waistcoats
      item_list = Waistcoat.where(employee: nil).sample(waistcoats).map(&:serial_number)
      items_description(item_list, 'serial_number')
    end

    def mount_radios
      item_list = Radio.where(employee: nil).sample(radios).map(&:serial_number)
      items_description(item_list, 'serial_number')
    end

    def mount_vehicles
      Vehicle.available.sample(vehicles).inject([]) do |list, vehicle|
        list << "#{vehicle.name} #{vehicle.color} - #{vehicle.license_plate}"
      end
             .sort
             .join(I18n.t('builders.mission_items.separator'))
    end

    def items_description(items_list, identifier)
      description = I18n.t("builders.mission_items.#{identifier}")

      items_list
        .inject([]) { |list, number| list << (description + number) }
        .sort
        .join(I18n.t('builders.mission_items.separator'))
    end

    def bullets_description(munition)
      "#{munition} #{I18n.t('builders.mission_items.bullets', count: munition)}"
    end
  end
end
