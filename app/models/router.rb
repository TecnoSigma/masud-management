class Router < ApplicationRecord
  include KitItemCallBacks

  validates :operator,
            :kind,
            :user,
            :password,
            :imei,
            presence: { message: Messages::errors[:required_field] }

  belongs_to :kit
end
