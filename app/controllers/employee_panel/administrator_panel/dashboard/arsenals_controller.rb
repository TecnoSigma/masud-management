# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      class ArsenalsController < EmployeePanelController
        before_action { check_internal_profile(params['controller']) }
      end
    end
  end
end
