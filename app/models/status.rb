class Status < ApplicationRecord
  validates :name, presence: true

  has_many :customers
  has_many :employees
  has_many :escorts
  has_many :vehicles
  has_many :arsenals
  has_many :clothes
end
