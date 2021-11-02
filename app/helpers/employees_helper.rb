# frozen_string_literal: true

module EmployeesHelper
  def profile(profile)
    Employee.profiles[profile.downcase.to_sym]
  end

  def highlight_expired_cvn(employee)
    if employee.agent? && employee.expired_cvn?
      'expired-cvn'
    else
      ''
    end
  end
end
