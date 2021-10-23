# frozen_string_literal: true

class ItemMovimentation < ApplicationRecord
  belongs_to :arsenal, optional: true
  belongs_to :tackle, optional: true
  belongs_to :vehicle, optional: true
end
