# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      module Arsenals
        class GunsController < ArsenalsController
          before_action { check_internal_profile(params['controller']) }

          def list
            @guns = Gun.all
          end

          def new; end

          def edit
            @gun = Gun.find(params['id'])
          rescue StandardError, ActiveRecord::RecordNotFound => error
            redirect_to employee_panel_administrator_dashboard_arsenais_armas_path,
                        alert: error_message(error.class, :find)
          end

          def create
            gun = Gun.new(gun_params)

            gun.validate
            gun.save!

            redirect_to employee_panel_administrator_dashboard_arsenais_armas_path,
                        notice: t('messages.successes.arsenal.gun.created_successfully',
                                  sinarm: gun.sinarm)
          rescue StandardError => error
            Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

            redirect_to employee_panel_administrator_dashboard_arsenais_arma_novo_path,
                        alert: t('messages.errors.arsenal.gun.create_failed')
          end

          def show
            @gun = Gun.find(params['id'])
          rescue StandardError, ActiveRecord::RecordNotFound => error
            redirect_to employee_panel_administrator_dashboard_arsenais_armas_path,
                        alert: error_message(error.class, :find)
          end

          def update
            gun = Gun.find(params['id'])

            gun.update!(gun_params)

            redirect_to employee_panel_administrator_dashboard_gun_show_path(gun.id),
                        notice: t('messages.successes.arsenal.gun.updated_successfully')
          rescue StandardError, ActiveRecord::RecordNotFound => error
            redirect_to employee_panel_administrator_dashboard_arsenais_armas_path,
                        alert: error_message(error.class, :update)
          end

          def remove
            delete_gun!

            redirect_to employee_panel_administrator_dashboard_arsenais_armas_path,
                        notice: t('messages.successes.arsenal.gun.removed_successfully',
                                  sinarm: gun.sinarm)
          rescue DeleteGunError
            redirect_to employee_panel_administrator_dashboard_arsenais_armas_path,
                        alert: t('messages.errors.arsenal.gun.remove_in_mission_failed')
          rescue StandardError, ActiveRecord::RecordNotFound => error
            redirect_to employee_panel_administrator_dashboard_arsenais_armas_path,
                        alert: error_message(error.class, :remove)
          end

          private

          def delete_gun!
            raise DeleteGunError if gun.in_mission?

            gun.delete
          end

          def gun
            @gun ||= Gun.find(params['id'])
          end

          def error_message(error_class, action)
            if error_class == ActiveRecord::RecordNotFound
              t('messages.errors.arsenal.gun.not_found')
            else
              t("messages.errors.#{action}_failed")
            end
          end

          def status_params!(formatted_params)
            if params['gun']['status']
              formatted_params.merge!('status' => Status.find_by_name(params['gun']['status']))
            else
              formatted_params
            end
          end

          def gun_params
            formatted_params = params
                               .require(:gun)
                               .permit(:kind, :caliber, :number, :sinarm, :registration_validity,
                                       :linked_at_post, :situation)

            status_params!(formatted_params)
          end
        end
      end
    end
  end
end
