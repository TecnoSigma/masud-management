class Bank < ApplicationRecord
  validates :compe_register,
            :name,
            presence: { message: Messages.errors[:required_field] }

  has_many :accounts
end
