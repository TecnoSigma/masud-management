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
  CALIBER_12_MAXIMUM_QUANTITY = 1
  CALIBER_38_MAXIMUM_QUANTITY = 2
  CALIBERS = { shotgun: '12', revolver: '38' }.freeze

  private_constant :CALIBER_12_MAXIMUM_QUANTITY, :CALIBER_38_MAXIMUM_QUANTITY, :CALIBERS

  def self.available(caliber)
    total = total_by_caliber(caliber).count
    quantity = const_get("CALIBER_#{caliber}_MAXIMUM_QUANTITY")

    (caliber == CALIBERS[CALIBERS.key(caliber)] && total < quantity) ? total : quantity
  end

  def self.total_by_caliber(caliber)
    where(caliber: caliber).where(employee: nil)
  end

  private_class_method :total_by_caliber
end
