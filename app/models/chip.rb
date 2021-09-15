class Chip < ApplicationRecord
  include KitItemCallBacks

  validates :kind,
            :status,
            presence: { message: Messages::errors[:required_field] }

  belongs_to :kit, optional: true
end
