# frozen_string_literal: true

module EmployeePanel
  module OperatorPanel
    class OrdersController < DashboardController
      def order_management
        session[:order_number] = params['order_number']

        @order = Order.find_by_order_number(params['order_number'])
      end

      def block_order
        return unless ActiveRecord::Type::Boolean.new.cast(params['block'])

        update_blocking_status!
        send_block_notification!

        redirect_to employee_panel_operator_dashboard_index_path,
                    alert: t('messages.errors.order.blocked', order_number: order.order_number)
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")
      end

      def refuse_order
        order = Order.find_by_order_number(refuse_params['order_number'])

        update_refuse_status!(order)

        redirect_to employee_panel_operator_dashboard_index_path,
                    notice: t('messages.successes.order.refused_successfully',
                              order_number: order.order_number)
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        redirect_to employee_panel_operator_dashboard_index_path,
                    alert: t('messages.errors.order.refuse_failed')
      end

      def confirm_order
        Builders::Mission.new(params['mission_info']).mount!

        redirect_to employee_panel_operator_dashboard_index_path,
                    notice: t('messages.successes.order.created_mission_successfully')
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        redirect_to employee_panel_operator_dashboard_index_path,
                    alert: t('messages.errors.order.create_mission_failed')
      end

      private

      def reason
        raise StandardError unless refuse_params['reason']

        t('messages.infos.refuse_reason', reason: refuse_params['reason'], employee: employee_name)
      end

      def order
        @order ||= Order.find_by_order_number(session[:order_number])
      end

      def update_blocking_status!
        order.update(
          status: Status.find_by_name('bloqueada'),
          reason: t('messages.infos.blocking_reason', employee_name: employee_name)
        )
      end

      def update_refuse_status!(order)
        order.update!(status: Status.find_by_name('cancelada'), reason: reason)
      end

      def employee_name
        ServiceToken.find_by_token(session[:employee_token]).employee.name
      end

      def send_block_notification!
        Notifications::Order.warn_about_blocking(
          order_number: order.order_number,
          blocking_date: order.updated_at,
          employee_token: session[:employee_token]
        ).deliver_now!
      end

      def refuse_params
        params
          .require(:refuse_info)
          .permit(:order_number, :reason)
      end
    end
  end
end
