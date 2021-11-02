# frozen_string_literal: true

class Bullet < ApplicationRecord
  belongs_to :employee

  validates :caliber,
            presence: true

  belongs_to :employee
end
