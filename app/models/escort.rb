# frozen_string_literal: true

class Escort < ApplicationRecord
  belongs_to :customer
  belongs_to :status
end
