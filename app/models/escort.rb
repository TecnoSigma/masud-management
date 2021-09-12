class Escort < ApplicationRecord
  belongs_to :customer
  belongs_to :status
end
