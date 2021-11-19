# frozen_string_literal: true

module EmployeePanel
  module OperatorPanel
    class MissionsController < DashboardController
      protect_from_forgery with: :null_session, only: [:mount_items_list]

      def missions
        @missions = Mission
                    .all
                    .paginate(per_page: Order::PER_PAGE_IN_EMPLOYEE_DASHBOARD,
                              page: params[:page])
      end

      def mission
        @mission = escort_service.mission
      end

      def exit_from_base
        update_mission!({ exit_from_base: DateTime.now })

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    notice: t('messages.successes.mission.updated_successfully')
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    alert: t('messages.errors.mission.update_failed')
      end

      def arrival_at_base
        update_mission!({ arrival_at_base: DateTime.now })

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    notice: t('messages.successes.mission.updated_successfully')
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    alert: t('messages.errors.mission.update_failed')
      end

      def start_mission
        update_mission!({ started_at: DateTime.now, status: Status.find_by_name('iniciada') })
        escort_service.update!(status: Status.find_by_name('iniciada'))

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    notice: t('messages.successes.mission.started_successfully')
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    alert: t('messages.errors.mission.start_failed')
      end

      def finish_mission
        mission = escort_service.mission

        Builders::FinishMission.new(mission, mission_params[:observation]).dismount!

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    notice: t('messages.successes.mission.finished_successfully')
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    alert: t('messages.errors.mission.finish_failed')
      end

      def mount_items_list
        descriptive_items = Builders::MissionItems.new(mission_item_params).mount!

        render json: { 'descriptive_items' => descriptive_items }, status: :ok
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        render json: { 'descriptive_items' => {} }, status: :internal_server_error
      end

      private

      def update_mission!(params)
        mission = escort_service.mission
        mission.update(params)
      end

      def escort_service
        @escort_service ||= EscortService.find_by_order_number(params['order_number'])
      end

      def mission_params
        params
          .require(:mission)
          .permit(:observation)
      end

      def mission_item_params
        params
          .require(:items)
          .permit(:calibers_12_quantity,
                  :calibers_38_quantity,
                  :munitions_12_quantity,
                  :munitions_38_quantity,
                  :waistcoats_quantity,
                  :radios_quantity,
                  :vehicles_quantity)
      end
    end
  end
end
