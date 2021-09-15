class Vehicle < ApplicationRecord
  validates :brand,
            :kind,
            :license_plate,
            :status,
            presence: { message: Messages.errors[:required_field] }

  validates :license_plate,
            uniqueness: { message: Messages.errors[:already_license_plate] }

  validates :license_plate,
            format: { with: Regex.license_plate, message: Messages.errors[:invalid_format] }

  validates :photos,
            presence: true,
            blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                    size_range: 1..5.megabytes }, unless: :new_vehicle?

  validate :allowed_photo_quantity?
  validate :allowed_status?

  has_and_belongs_to_many :drivers
  belongs_to :subscriber
  has_many_attached :photos

  ALLOWED_PHOTO_QUANTITY = 3.freeze
  ALLOWED_STATUSES = [Status::STATUSES[:activated],
                      Status::STATUSES[:deactivated],
                      Status::STATUSES[:deleted]]

  scope :sort_by_license_plate, lambda { sort_by { |vehicle| vehicle.license_plate } }

  def new_vehicle?
    !self.persisted?
  end

  def allowed_photo_quantity?
    return unless self.persisted? && self.photos.any?

    unless self.photos.count == ALLOWED_PHOTO_QUANTITY
      errors.add(:photos, Messages.errors[:not_allowed_photo_quantity])
    end
  end

  def allowed_status?
    if ALLOWED_STATUSES.exclude?(self.status)
      errors.add(:status, Messages.errors[:invalid_status])
    end
  end

  def have_photos?
    self.photos.any?
  end
end
