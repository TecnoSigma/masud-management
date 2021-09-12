class Employee < ApplicationRecord
  belongs_to :status

  before_save :add_kind

  def add_kind
    self.kind = self.class.name.downcase
  end
end
