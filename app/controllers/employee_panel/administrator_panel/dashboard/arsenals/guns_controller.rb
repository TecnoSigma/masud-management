# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      module Arsenals
        class GunsController < EmployeePanelController
          before_action { check_internal_profile(params['controller']) }

          def list
            @guns = Gun.all
          end

          def new; end

          #def edit
          #  @tackle = Tackle.find(params['id'])
          #rescue StandardError, ActiveRecord::RecordNotFound => error
          #  redirect_to employee_panel_administrator_dashboard_equipamentos_path,
          #              alert: error_message(error.class, :find)
          #end

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

          #def update
          #  tackle = Tackle.find(params['id'])

          #  tackle.update!(tackle_params)

          #  redirect_to employee_panel_administrator_dashboard_tackle_show_path(tackle.id),
          #              notice: t('messages.successes.tackle.updated_successfully')
          #rescue StandardError, ActiveRecord::RecordNotFound => error
          #  redirect_to employee_panel_administrator_dashboard_equipamentos_path,
          #              alert: error_message(error.class, :update)
          #end

          def remove
            delete_tackle!

            redirect_to employee_panel_administrator_dashboard_equipamentos_path,
                        notice: t('messages.successes.tackle.removed_successfully',
                                  type: tackle_type, serial_number: tackle.serial_number)
          rescue DeleteTackleError
            redirect_to employee_panel_administrator_dashboard_equipamentos_path,
                        alert: t('messages.errors.tackle.remove_in_mission_failed')
          rescue StandardError, ActiveRecord::RecordNotFound => error
            redirect_to employee_panel_administrator_dashboard_equipamentos_path,
                        alert: error_message(error.class, :remove)
          end

          private

          #def delete_tackle!
          #  raise DeleteTackleError if tackle.in_mission?

          #  tackle.delete
          #end

          #def tackle
          #  @tackle ||= Tackle.find(params['id'])
          #end

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
