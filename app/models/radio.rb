# frozen_string_literal: true

class Radio < Tackle
  validates :serial_number,
            presence: true
end
