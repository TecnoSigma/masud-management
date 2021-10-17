# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      class EmployeesController < EmployeePanelController
        before_action { check_internal_profile(params['controller']) }

        def new; end

        def edit
          @employee = Employee.find(params['id'])
        rescue StandardError, ActiveRecord::RecordNotFound => error
          redirect_to employee_panel_administrator_dashboard_funcionarios_path,
                      alert: error_message(error.class, :find)
        end

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

        def update
          employee = Employee.find(params['id'])

          employee.update!(employee_params)

          redirect_to employee_panel_administrator_dashboard_employee_show_path(employee.id),
                      notice: t('messages.successes.employee.updated_successfully')
        rescue StandardError, ActiveRecord::RecordNotFound => error
          redirect_to employee_panel_administrator_dashboard_funcionarios_path,
                      alert: error_message(error.class, :update)
        end

        def remove
          employee = Employee.find(params['id'])

          employee.update!(deleted_at: DateTime.now, status: Status.find_by_name('deletado'))

          redirect_to employee_panel_administrator_dashboard_funcionarios_path,
                      notice: t('messages.successes.employee.removed_successfully',
                                employee_name: employee.name)
        rescue StandardError, ActiveRecord::RecordNotFound => error
          redirect_to employee_panel_administrator_dashboard_funcionarios_path,
                      alert: error_message(error.class, :remove)
        end

        private

        def employee_klass
          return Employee unless params['employee']['profile']

          Employee::PROFILES
            .keys
            .map(&:to_s)
            .detect { |profile| profile if profile == params['employee']['profile'] }
            .titleize
            .constantize
        end

        def error_message(error_class, action)
          if error_class == ActiveRecord::RecordNotFound
            t('messages.errors.employee.not_found')
          else
            t("messages.errors.#{action}_failed")
          end
        end

        def update_params!(formatted_params)
          if params['action'] == 'update'
            formatted_params
          else
            formatted_params.merge!('password' => Employee.generate_password)
          end
        end

        def profile_params!(formatted_params)
          if params['employee']['profile']
            formatted_params.merge!('type' => params['employee']['profile'].titleize)
          else
            formatted_params
          end
        end

        def status_params!(formatted_params)
          if params['employee']['status']
            formatted_params.merge!('status' => Status.find_by_name(params['employee']['status']))
          else
            formatted_params
          end
        end

        def employee_params
          formatted_params = params
                             .require(:employee)
                             .permit(:name, :codename, :email, :rg, :cpf, :cvn_number,
                                     :cvn_validation_date, :admission_date, :resignation_date)

          update_params!(formatted_params)
          profile_params!(formatted_params)
          status_params!(formatted_params)
        end
      end
    end
  end
end
