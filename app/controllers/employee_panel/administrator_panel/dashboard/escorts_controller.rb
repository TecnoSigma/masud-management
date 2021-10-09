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

        def show
          @escort = Order.find_by_order_number(params['order_number'])

          raise FindEscortError unless @escort
          raise TypeError unless @escort.escort?
        rescue FindEscortError, TypeError, StandardError => error
          redirect_to '/gestao/admin/dashboard/escoltas/scheduled',
                      alert: error_message(error.class)
        end

        private

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
