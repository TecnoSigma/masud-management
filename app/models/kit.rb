class Kit < ApplicationRecord
  before_save :default_serial_number 

  has_one :camera
  has_one :router
  has_one :chip
  belongs_to :subscriber, optional: true

  def default_serial_number
    self.serial_number || self.serial_number = SecureRandom.uuid.upcase.remove('-') 
  end
end
