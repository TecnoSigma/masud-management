class MunitionStock < ApplicationRecord
  validates :caliber,
            :quantity,
            :last_update,
            presence: true
end
