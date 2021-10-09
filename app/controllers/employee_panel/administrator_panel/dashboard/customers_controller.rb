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

        def create
          customer = Customer.new(customer_params)

          customer.validate
          customer.save!

          redirect_to employee_panel_administrator_dashboard_clientes_path,
                      notice: t('messages.successes.customer.created_successfully',
                                company: customer.company)
        rescue StandardError => error
          Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

          redirect_to employee_panel_administrator_dashboard_cliente_novo_path,
            alert: t('messages.errors.customer.create_customer_failed')
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

        private

        def customer_params
          params
            .require(:customer)
            .permit(:company, :cnpj, :telephone, :email, :secondary_email, :tertiary_email)
            .merge('status' => Status.find_by_name(params['customer']['status']))
        end
      end
    end
  end
end
