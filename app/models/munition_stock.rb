# frozen_string_literal: true

class MunitionStock < ApplicationRecord
  validates :caliber,
            :quantity,
            :last_update,
            presence: true

  validates :quantity,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
