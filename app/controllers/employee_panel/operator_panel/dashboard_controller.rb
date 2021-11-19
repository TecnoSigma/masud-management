# frozen_string_literal: true

module EmployeePanel
  module OperatorPanel
    class DashboardController < EmployeePanelController
      before_action except: [:mount_items_list] do
        check_internal_profile(params['controller'])
      end

      def index
        @scheduled_escorts = Order
                             .scheduled('EscortScheduling')
                             .paginate(per_page: Order::PER_PAGE_IN_EMPLOYEE_DASHBOARD,
                                       page: params[:page])
      end
    end
  end
end
