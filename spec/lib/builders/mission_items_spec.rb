# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Builders::MissionItems' do
  describe '#mount!' do
    it 'mounts mission items list' do
      calibers_12_quantity = '2'
      calibers_38_quantity = '5'
      munitions_12_quantity = '24'
      munitions_38_quantity = '50'
      waistcoats_quantity = '3'
      radios_quantity = '1'
      vehicles_quantity = '1'

      items = {
        'calibers_12_quantity' => calibers_12_quantity,
        'calibers_38_quantity' => calibers_38_quantity,
        'munitions_12_quantity' => munitions_12_quantity,
        'munitions_38_quantity' => munitions_38_quantity,
        'waistcoats_quantity' => waistcoats_quantity,
        'radios_quantity' => radios_quantity,
        'vehicles_quantity' => vehicles_quantity
      }

      guns_list = %w[ABC1234 XPTO9999]
      waistcoats_list = %w[W1234 W5678]
      radios_list = %w[R1234 R5678]
      car_brand = 'Mercedes'
      car_color = 'Preto'
      car_license_plate = 'XYZ 9999'

      allow(Gun).to receive_message_chain(:available, :sample, :map) { guns_list }
      allow(Waistcoat).to receive_message_chain(:available, :sample, :map) { waistcoats_list }
      allow(Radio).to receive_message_chain(:available, :sample, :map) { radios_list }

      vehicle = double

      allow(vehicle).to receive(:name) { car_brand }
      allow(vehicle).to receive(:color) { car_color }
      allow(vehicle).to receive(:license_plate) { car_license_plate }
      allow(Vehicle).to receive_message_chain(:available, :sample) { [vehicle] }

      expected_result = { calibers12: "Nº #{guns_list.first} | Nº #{guns_list.last}",
                          calibers38: "Nº #{guns_list.first} | Nº #{guns_list.last}",
                          munitions12: "#{munitions_12_quantity} projéteis",
                          munitions38: "#{munitions_38_quantity} projéteis",
                          waistcoats: "Nº Série #{waistcoats_list.first} | Nº Série #{waistcoats_list.last}",
                          radios: "Nº Série #{radios_list.first} | Nº Série #{radios_list.last}",
                          vehicles: "#{car_brand} #{car_color} - #{car_license_plate}" }

      result = Builders::MissionItems.new(items).mount!

      expect(result).to eq(expected_result)
    end
  end
end
