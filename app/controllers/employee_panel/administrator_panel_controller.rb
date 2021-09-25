# frozen_string_literal: true

class EmployeePanel::AdministratorPanelController < EmployeePanelController
  before_action { check_internal_profile(params['controller']) }

  def dashboard; end
end
