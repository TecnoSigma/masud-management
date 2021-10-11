# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      class EmployeesController < EmployeePanelController
        before_action { check_internal_profile(params['controller']) }

        #def new; end

        #def edit
        #  @customer = Customer.find(params['id'])
        #rescue StandardError, ActiveRecord::RecordNotFound => error
        #  redirect_to employee_panel_administrator_dashboard_clientes_path,
        #              alert: error_message(error.class, :find)
        #end

        def list
          @employees = Employee
                       .all
                       .paginate(per_page: Customer::PER_PAGE_IN_EMPLOYEE_DASHBOARD,
                                 page: params[:page])
        end

        #def create
        #  customer = Customer.new(customer_params)

        #  customer.validate
        #  customer.save!

        #  redirect_to employee_panel_administrator_dashboard_clientes_path,
        #              notice: t('messages.successes.customer.created_successfully',
        #                        company: customer.company)
        #rescue StandardError => error
        #  Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        #  redirect_to employee_panel_administrator_dashboard_cliente_novo_path,
        #              alert: t('messages.errors.customer.create_customer_failed')
        #end

        #def show
        #  @customer = Customer.find(params['id'])
        #rescue StandardError, ActiveRecord::RecordNotFound => error
        #  redirect_to employee_panel_administrator_dashboard_clientes_path,
        #              alert: error_message(error.class, :find)
        #end

        #def update
        #  customer = Customer.find(params['id'])

        #  customer.update!(customer_params)

        #  redirect_to employee_panel_administrator_dashboard_customer_show_path(customer.id),
        #              notice: t('messages.successes.customer.updated_successfully')
        #rescue StandardError, ActiveRecord::RecordNotFound => error
        #  redirect_to employee_panel_administrator_dashboard_clientes_path,
        #              alert: error_message(error.class, :update)
        #end

        #def remove
        #  customer = Customer.find(params['id'])

        #  customer.update!(deleted_at: DateTime.now, status: Status.find_by_name('deletado'))

        #  redirect_to employee_panel_administrator_dashboard_clientes_path,
        #              notice: t('messages.successes.customer.removed_successfully',
        #                        company: customer.company)
        #rescue StandardError, ActiveRecord::RecordNotFound => error
        #  redirect_to employee_panel_administrator_dashboard_clientes_path,
        #              alert: error_message(error.class, :remove)
        #end

        #private

        #def error_message(error_class, action)
        #  if error_class == ActiveRecord::RecordNotFound
        #    t('messages.errors.customer.not_found')
        #  else
        #    t("messages.errors.#{action}_failed")
        #  end
        #end

        #def customer_params
        #  formatted_params = params
        #                     .require(:customer)
        #                     .permit(:company, :cnpj, :telephone, :email, :secondary_email, :tertiary_email)

        #  if params['customer']['status']
        #    formatted_params.merge('status' => Status.find_by_name(params['customer']['status']))
        #  else
        #    formatted_params
        #  end
        #end
      end
    end
  end
end
