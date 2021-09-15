class DeliveryCity < ApplicationRecord
  validates :federative_unit,
            :locality,
            :initial_postal_code,
            :final_postal_code,
            :express_time,
            :express_time,
            :price,
            :distributor,
            :road_time,
            :risk_group,
            presence: { message: Messages.errors[:required_field] }

  validates :express_time,
            :road_time,
            :risk_group,
            numericality: { only_integer: true,
                            message: Messages.errors[:invalid_format] }
end
