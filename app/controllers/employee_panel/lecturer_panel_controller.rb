# frozen_string_literal: true

module EmployeePanel
  class LecturerPanelController < EmployeePanelController
    before_action { check_internal_profile(params['controller']) }

    def dashboard; end
  end
end
