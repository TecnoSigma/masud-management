# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      module Arsenals
        class MunitionsController < ArsenalsController
          before_action { check_internal_profile(params['controller']) }

          def list
            @munitions = MunitionStock.all
          end

          def new; end

          def edit
            @munition = MunitionStock.find(params['id'])
          rescue StandardError, ActiveRecord::RecordNotFound => error
            redirect_to employee_panel_administrator_dashboard_arsenais_municoes_path,
                        alert: error_message(error.class, :find)
          end

          def create
            munition = MunitionStock.new(munition_params)

            munition.validate
            munition.save!

            redirect_to employee_panel_administrator_dashboard_arsenais_municoes_path,
                        notice: t('messages.successes.arsenal.munition.created_successfully',
                                  caliber_type: munition.caliber)
          rescue StandardError => error
            Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

            redirect_to employee_panel_administrator_dashboard_arsenais_municao_novo_path,
                        alert: t('messages.errors.arsenal.munition.create_failed')
          end

          def update
            munition = MunitionStock.find(params['id'])

            munition.update!(munition_params)

            redirect_to employee_panel_administrator_dashboard_arsenais_municoes_path,
                        notice: t('messages.successes.arsenal.munition.updated_successfully')
          rescue StandardError, ActiveRecord::RecordNotFound => error
            redirect_to employee_panel_administrator_dashboard_arsenais_municoes_path,
                        alert: error_message(error.class, :update)
          end

          def remove
            munition.delete

            redirect_to employee_panel_administrator_dashboard_arsenais_municoes_path,
                        notice: t('messages.successes.arsenal.munition.removed_successfully',
                                  caliber_type: munition.caliber)
          rescue StandardError, ActiveRecord::RecordNotFound => error
            redirect_to employee_panel_administrator_dashboard_arsenais_municoes_path,
                        alert: error_message(error.class, :remove)
          end

          private

          def munition
            @munition ||= MunitionStock.find(params['id'])
          end

          def error_message(error_class, action)
            if error_class == ActiveRecord::RecordNotFound
              t('messages.errors.arsenal.munition.not_found')
            else
              t("messages.errors.#{action}_failed")
            end
          end

          def munition_params
            params
              .require(:munition)
              .permit(:caliber, :quantity)
              .merge!({ 'last_update' => DateTime.now })
          end
        end
      end
    end
  end
end
