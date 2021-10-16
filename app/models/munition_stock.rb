# frozen_string_literal: true

class MunitionStock < ApplicationRecord
  validates :caliber,
            :quantity,
            :last_update,
            presence: true
end
