# frozen_string_literal: true

class Munition < Arsenal
  validates :kind,
            :quantity,
            presence: true
end
