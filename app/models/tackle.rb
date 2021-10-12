# frozen_string_literal: true

class Tackle < ApplicationRecord
  belongs_to :agent, optional: true
  belongs_to :status

  ALLOWED_TYPES = { radio: 'rádio', waistcoat: 'colete' }
end
