class Camera < ApplicationRecord
  include KitItemCallBacks

  DEFAULT_USER = 'admin'.freeze

  validates :kind,
            :ip,
            :user,
            :password,
            :status,
            presence: { message: Messages::errors[:required_field] }

  validate :check_default_user

  belongs_to :kit

  def check_default_user
    return if self.persisted?

    unless self.user == DEFAULT_USER
      errors.add(:user, Messages::errors[:invalid_user])
    end
  end
end
