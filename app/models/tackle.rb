# frozen_string_literal: true

class Tackle < ApplicationRecord
  belongs_to :agent, optional: true
  belongs_to :status
end
