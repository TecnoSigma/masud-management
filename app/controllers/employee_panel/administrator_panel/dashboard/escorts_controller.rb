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

        def unblock
          update_escort!

          redirect_to '/gestao/admin/dashboard/escoltas/blocked',
                      notice: t('messages.successes.order_unblocked_successfully',
                                order_number: order.order_number)
        rescue StandardError => error
          Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

          redirect_to '/gestao/admin/dashboard/escoltas/blocked',
                      alert: t('messages.errors.unblock_failed',
                               order_number: params['order_number'])
        end

        def show
          @escort = order

          raise FindEscortError unless @escort
          raise TypeError unless @escort.escort?
        rescue FindEscortError, TypeError => error
          redirect_to '/gestao/admin/dashboard/escoltas/scheduled',
                      alert: error_message(error.class)
        end

        private

        def update_escort!
          raise FindEscortError unless order

          order.update(status: Status.find_by_name('agendado'), reason: nil)
        end

        def order
          @order ||= Order.find_by_order_number(params['order_number'])
        end

        def error_message(error_class)
          if [FindEscortError, TypeError].include?(error_class)
            t('messages.errors.escort.not_found')
          else
            t('messages.errors.find_failed')
          end
        end
      end
    end
  end
end
