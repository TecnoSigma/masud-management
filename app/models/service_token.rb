class ServiceToken < ApplicationRecord
  validates :token, presence: true

  belongs_to :customer, optional: true
  belongs_to :employee, optional: true
end
