# frozen_string_literal: true

class Escort < Service
  belongs_to :customer
  belongs_to :status
end
