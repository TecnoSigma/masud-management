class Customer < ApplicationRecord
  belongs_to :status
  has_many :escorts
end
