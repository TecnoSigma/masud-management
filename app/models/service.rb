# frozen_string_literal: true

class Service < ApplicationRecord
  belongs_to :customer
  belongs_to :status
end
