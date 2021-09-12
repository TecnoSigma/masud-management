class Customer < ApplicationRecord
  validates :email,
            :password,
            presence: true

  belongs_to :status
  has_many :escorts
end
