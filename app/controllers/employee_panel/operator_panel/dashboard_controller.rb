# frozen_string_literal: true

module EmployeePanel
  module OperatorPanel
    class DashboardController < EmployeePanelController
      protect_from_forgery with: :null_session, only: [:mount_items_list]

      before_action except: [:mount_items_list] do
        check_internal_profile(params['controller'])
      end

      def index
        @scheduled_escorts = Order
                             .scheduled('EscortScheduling')
                             .paginate(per_page: Order::PER_PAGE_IN_EMPLOYEE_DASHBOARD,
                                       page: params[:page])
      end

      def order_management
        @order = Order.find_by_order_number(params['order_number'])
      end

      def mount_team
        team = Builders::Team.new(team_params['quantity']).mount!

        render json: { 'team' => team }, status: :ok
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        render json: { 'team' => {} }, status: :internal_server_error
      end

      def mount_items_list
        descriptive_items = Builders::MissionItems.new(mission_item_params).mount!

        render json: { 'descriptive_items' => descriptive_items }, status: :ok
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        render json: { 'descriptive_items' => {} }, status: :internal_server_error
      end

      def refuse; end

      private

      def team_params
        params
          .require(:agent)
          .permit(:quantity)
      end

      def mission_item_params
        params
          .require(:items)
          .permit(:calibers_12_quantity,
                  :calibers_38_quantity,
                  :munitions_12_quantity,
                  :munitions_38_quantity,
                  :waistcoats_quantity,
                  :radios_quantity,
                  :vehicles_quantity)
      end
    end
  end
end
