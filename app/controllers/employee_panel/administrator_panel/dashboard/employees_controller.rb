# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      class EmployeesController < EmployeePanelController
        before_action { check_internal_profile(params['controller']) }

        def new; end

        #def edit
        #  @customer = Customer.find(params['id'])
        #rescue StandardError, ActiveRecord::RecordNotFound => error
        #  redirect_to employee_panel_administrator_dashboard_clientes_path,
        #              alert: error_message(error.class, :find)
        #end

        def list
          @employees = Employee.all
        end

        def create
          employee = employee_klass.new(employee_params)

          employee.validate
          employee.save!

          redirect_to employee_panel_administrator_dashboard_funcionarios_path,
                      notice: t('messages.successes.employee.created_successfully',
                                employee_name: employee.name)
        rescue StandardError => error
          Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

          redirect_to employee_panel_administrator_dashboard_funcionario_novo_path,
                      alert: t('messages.errors.employee.create_failed')
        end

        def show
          @employee = Employee.find(params['id'])
        rescue StandardError, ActiveRecord::RecordNotFound => error
          redirect_to employee_panel_administrator_dashboard_funcionarios_path,
                      alert: error_message(error.class, :find)
        end

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

       private

        def employee_klass
          params['employee']['profile'].titleize.constantize
        end

        def error_message(error_class, action)
          if error_class == ActiveRecord::RecordNotFound
            t('messages.errors.employee.not_found')
          else
            t("messages.errors.#{action}_failed")
          end
        end

        def employee_params
          formatted_params = params
                             .require(:employee)
                             .permit(:name, :codename, :email, :rg, :cpf, :cvn_number,
                                     :cvn_validation_date, :admission_date, :resignation_date)

          formatted_params.merge!('password' => Employee.generate_password)

          params['employee']['status'] ?
            formatted_params.merge('status' => Status.find_by_name(params['employee']['status'])) :
            formatted_params
        end
      end
    end
  end
end
