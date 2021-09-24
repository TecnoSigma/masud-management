# frozen_string_literal: true

class Operator < Employee
  validates :codename,
            :cvn_number,
            :cvn_validation_date,
            presence: true
end
