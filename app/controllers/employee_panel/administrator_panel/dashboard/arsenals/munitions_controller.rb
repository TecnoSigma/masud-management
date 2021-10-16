# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      module Arsenals
        class MunitionsController < ArsenalsController
          before_action { check_internal_profile(params['controller']) }

          def list
            @munitions = Munition.all
          end

          def new; end

          def create
            munition = Munition.new(munition_params)

            munition.validate
            munition.save!

            redirect_to employee_panel_administrator_dashboard_arsenais_municoes_path,
                        notice: t('messages.successes.arsenal.munition.created_successfully',
                                  caliber_type: munition.kind)
          rescue StandardError => error
            Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

            redirect_to employee_panel_administrator_dashboard_arsenais_municao_novo_path,
                        alert: t('messages.errors.arsenal.munition.create_failed')
          end

          private

          def munition_params
            params.require(:munition).permit(:kind, :quantity)
          end
        end
      end
    end
  end
end
