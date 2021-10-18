# frozen_string_literal: true

module EmployeePanel
  module OperatorPanel
    class DashboardController < EmployeePanelController
      before_action { check_internal_profile(params['controller']) }

      def index; end
    end
  end
end
