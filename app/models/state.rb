class State < ApplicationRecord
  validates :name,
            :external_id,
            presence: true

  validates :external_id, numericality: { only_integer: true, greater_than: 0 }

  has_many :cities, dependent: :destroy
end
