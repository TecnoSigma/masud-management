class Profile < ApplicationRecord
  validates :name,
            :kind,
            presence: true
  has_and_belongs_to_many :employees
end
