# frozen_string_literal: true

class Munition < Arsenal
  validates :kind,
            :quantity,
            presence: true

  scope :free, ->(kind) { where(kind: kind).where(employee: nil) }
end
