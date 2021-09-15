class Account < ApplicationRecord
  validates :agency,
            :number,
            presence: { message: Messages.errors[:required_field] }

  belongs_to :bank
  belongs_to :seller
end
