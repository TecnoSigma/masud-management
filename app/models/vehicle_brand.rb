class VehicleBrand < ApplicationRecord
  has_many :vehicle_models

  scope :actives, -> { order(:brand).select { |vehicle| vehicle unless vehicle.brand == 'ND' } }
end
