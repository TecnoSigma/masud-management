# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      class EscortsController < EmployeePanelController
        before_action { check_internal_profile(params['controller']) }

        def escorts
          @escorts = Order
            .filtered_escorts_by(params['status'])
            .paginate(per_page: Order::PER_PAGE_IN_EMPLOYEE_DASHBOARD,
                      page: params[:page])
        end
      end
    end
  end
end
