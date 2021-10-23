# frozen_string_literal: true

module EmployeePanel
  module OperatorPanel
    class DashboardController < EmployeePanelController
      before_action { check_internal_profile(params['controller']) }

      def index
        @scheduled_escorts = Order
                             .scheduled('EscortScheduling')
                             .paginate(per_page: Order::PER_PAGE_IN_EMPLOYEE_DASHBOARD,
                                       page: params[:page])
      end

      def order_management
        @order = Order.find_by_order_number(params['order_number'])
      end

      def refuse

      end
    end
  end
end
