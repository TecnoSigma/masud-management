# frozen_string_literal: true

class Gun < Arsenal
  validates :number,
            :kind,
            :caliber,
            :sinarm,
            :situation,
            :registration_validity,
            presence: true

  ALLOWED_TYPES = { shotgun: 'Espingarda', revolver: 'Revólver' }.freeze

  scope :available, ->(caliber) { where(caliber: caliber).where(employee: nil) }
end
