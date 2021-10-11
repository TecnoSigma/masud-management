# frozen_string_literal: true

module EmployeesHelper
  def profile(profile)
    Employee::PROFILES[profile.downcase.to_sym]
  end
end
