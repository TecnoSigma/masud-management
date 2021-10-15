# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      class ArsenalsController < EmployeePanelController
        before_action { check_internal_profile(params['controller']) }

        def guns_list
          @guns = Gun.all
        end

        def munitions_list
          @munitions = Munition.all
        end

        #def new; end

        #def edit
        #  @tackle = Tackle.find(params['id'])
        #rescue StandardError, ActiveRecord::RecordNotFound => error
        #  redirect_to employee_panel_administrator_dashboard_equipamentos_path,
        #              alert: error_message(error.class, :find)
        #end

        #def list
        #  @tackles = Tackle.all
        #end

        #def create
        #  tackle = tackle_klass.new(tackle_params)

        #  tackle.validate
        #  tackle.save!

        #  redirect_to employee_panel_administrator_dashboard_equipamentos_path,
        #              notice: t('messages.successes.tackle.created_successfully',
        #                        serial_number: tackle.serial_number)
        #rescue StandardError => error
        #  Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        #  redirect_to employee_panel_administrator_dashboard_equipamento_novo_path,
        #              alert: t('messages.errors.tackle.create_failed')
        #end

        def show_gun
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

        def remove_gun
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

        #private

        #def delete_tackle!
        #  raise DeleteTackleError if tackle.in_mission?

        #  tackle.delete
        #end

        #def tackle
        #  @tackle ||= Tackle.find(params['id'])
        #end

        #def tackle_type
        #  Tackle::ALLOWED_TYPES[tackle.type.downcase.to_sym]
        #end

        #def tackle_klass
        #  return Tackle unless params['tackle']['type']

        #  params['tackle']['type'].titleize.constantize
        #end

        def error_message(error_class, action)
          if error_class == ActiveRecord::RecordNotFound
            t('messages.errors.arsenal.gun.not_found')
          else
            t("messages.errors.#{action}_failed")
          end
        end

        #def type_params!(formatted_params)
        #  if params['tackle']['type']
        #    formatted_params.merge!('type' => params['tackle']['type'].titleize)
        #  else
        #    formatted_params
        #  end
        #end

        #def status_params!(formatted_params)
        #  if params['tackle']['status']
        #    formatted_params.merge!('status' => Status.find_by_name(params['tackle']['status']))
        #  else
        #    formatted_params
        #  end
        #end

        #def tackle_params
        #  formatted_params = params
        #                     .require(:tackle)
        #                     .permit(:serial_number, :register_number, :brand, :fabrication_date,
        #                             :status, :validation_date, :bond_date, :protection_level,
        #                             :situation)

        #  type_params!(formatted_params)
        #  status_params!(formatted_params)
        #end
      end
    end
  end
end
