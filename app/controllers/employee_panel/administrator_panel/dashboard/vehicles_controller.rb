# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      class VehiclesController < ArsenalsController
        before_action { check_internal_profile(params['controller']) }

        def list
          @vehicles = Vehicle.all
        end

        def new; end

        def edit
          @gun = Gun.find(params['id'])
        rescue StandardError, ActiveRecord::RecordNotFound => error
          redirect_to employee_panel_administrator_dashboard_arsenais_armas_path,
                      alert: error_message(error.class, :find)
        end

        def create
          vehicle = Vehicle.new(vehicle_params)

          vehicle.validate
          vehicle.save!

          redirect_to employee_panel_administrator_dashboard_viaturas_path,
                      notice: t('messages.successes.vehicle.created_successfully',
                                license_plate: vehicle.license_plate)
        rescue StandardError => error
          Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

          redirect_to employee_panel_administrator_dashboard_viatura_novo_path,
                      alert: t('messages.errors.vehicle.create_failed')
        end

        def show
          @vehicle = Vehicle.find(params['id'])
        rescue StandardError, ActiveRecord::RecordNotFound => error
          redirect_to employee_panel_administrator_dashboard_viaturas_path,
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
            t('messages.errors.vehicle.not_found')
          else
            t("messages.errors.#{action}_failed")
          end
        end

        def status_params!(formatted_params)
          if params['vehicle']['status']
            formatted_params.merge!('status' => Status.find_by_name(params['vehicle']['status']))
          else
            formatted_params
          end
        end

        def vehicle_params
          formatted_params = params
                             .require(:vehicle)
                             .permit(:name, :license_plate, :color)

          status_params!(formatted_params)
        end
      end
    end
  end
end
