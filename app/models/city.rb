# frozen_string_literal: true

class City < ApplicationRecord
  validates :name, presence: true

  belongs_to :state
end
