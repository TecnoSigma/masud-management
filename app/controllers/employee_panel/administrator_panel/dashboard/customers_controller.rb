# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      class CustomersController < EmployeePanelController
        before_action { check_internal_profile(params['controller']) }

        def new; end

        def list
          @customers = Customer
                         .all
                         .paginate(per_page: Customer::PER_PAGE_IN_EMPLOYEE_DASHBOARD,
                                   page: params[:page])
        end

        #def show
        #  @escort = Order.find_by_order_number(params['order_number'])

        #  raise FindEscortError unless @escort
        #  raise TypeError unless @escort.escort?
        #rescue FindEscortError, TypeError, StandardError => error
        #  redirect_to '/gestao/admin/dashboard/escoltas/scheduled',
        #              alert: error_message(error.class)
        #end

        #private

        #def error_message(error_class)
        #  if [FindEscortError, TypeError].include?(error_class)
        #    t('messages.errors.escort.not_found')
        #  else
        #    t('messages.errors.escort.find_failed')
        #  end
        #end
      end
    end
  end
end
