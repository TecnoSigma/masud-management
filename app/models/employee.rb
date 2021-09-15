# frozen_string_literal: true

class Employee < ApplicationRecord
  validates :email,
            :password,
            presence: true

  belongs_to :status

  before_save :add_kind

  ACTIVE_STATUS = 'ativo'

  private_constant :ACTIVE_STATUS

  def active?
    status.name == ACTIVE_STATUS
  end

  def add_kind
    class_name = self.class.name.downcase

    return if class_name == 'employee'

    self.kind = class_name
  end
end
