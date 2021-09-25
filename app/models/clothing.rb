# frozen_string_literal: true

class Clothing < ApplicationRecord
  belongs_to :employee
  belongs_to :status
end
