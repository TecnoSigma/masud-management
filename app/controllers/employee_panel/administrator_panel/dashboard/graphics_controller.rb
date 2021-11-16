# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      class GraphicsController < EmployeePanelController
        before_action { check_internal_profile(params['controller']) }

        def escorts_by_status
          chart_data = Order.chart_by_status

          render json: { 'chart_data' => chart_data }, status: :ok
        rescue StandardError => error
          Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

          render json: { 'chart_data' => [] }, status: :internal_server_error
        end
      end
    end
  end
end
