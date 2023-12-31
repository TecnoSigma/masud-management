# frozen_string_literal: true

class Status < ApplicationRecord
  validates :name, presence: true

  has_many :customers
  has_many :employees
  has_many :orders
  has_many :vehicles
  has_many :arsenals
  has_many :tackles
end
