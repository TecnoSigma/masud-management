# frozen_string_literal: true

module EmployeePanel
  module OperatorPanel
    class DashboardController < EmployeePanelController
      protect_from_forgery with: :null_session, only: [:mount_items_list]

      before_action except: [:mount_items_list] do
        check_internal_profile(params['controller'])
      end

      def missions
        @missions = Mission
                    .all
                    .paginate(per_page: Order::PER_PAGE_IN_EMPLOYEE_DASHBOARD,
                              page: params[:page])
      end

      def mission
        @mission = escort_service.mission
      end

      def index
        @scheduled_escorts = Order
                             .scheduled('EscortScheduling')
                             .paginate(per_page: Order::PER_PAGE_IN_EMPLOYEE_DASHBOARD,
                                       page: params[:page])
      end

      def exit_from_base
        mission = escort_service.mission
        mission.update(exit_from_base: DateTime.now)

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    notice: t('messages.successes.mission.updated_successfully')
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    alert: t('messages.errors.mission.update_failed')
      end

      def arrival_at_base
        mission = escort_service.mission
        mission.update(arrival_at_base: DateTime.now)

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    notice: t('messages.successes.mission.updated_successfully')
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    alert: t('messages.errors.mission.update_failed')
      end

      def start_mission
        mission = escort_service.mission
        mission.update(started_at: DateTime.now, status: Status.find_by_name('iniciada'))

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    notice: t('messages.successes.mission.started_successfully')
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    alert: t('messages.errors.mission.start_failed')
      end

      def finish_mission
        mission = escort_service.mission

        Builders::FinishMission.new(mission).dismount!

        mission.update(finished_at: DateTime.now, observation: mission_params[:observation])

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    notice: t('messages.successes.mission.finished_successfully')
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        redirect_to employee_panel_operator_dashboard_missoes_path,
                    alert: t('messages.errors.mission.finish_failed')
      end

      def order_management
        session[:order_number] = params['order_number']

        @order = Order.find_by_order_number(params['order_number'])
      end

      def mount_team
        team = Builders::Team.mount!

        render json: { 'team' => team }, status: :ok
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        render json: { 'team' => {} }, status: :internal_server_error
      end

      def mount_items_list
        descriptive_items = Builders::MissionItems.new(mission_item_params).mount!

        render json: { 'descriptive_items' => descriptive_items }, status: :ok
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        render json: { 'descriptive_items' => {} }, status: :internal_server_error
      end

      def block_order
        return unless ActiveRecord::Type::Boolean.new.cast(params['block'])

        update_blocking_status!
        send_block_notification!

        redirect_to employee_panel_operator_dashboard_index_path,
                    alert: t('messages.errors.order.blocked', order_number: order.order_number)
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")
      end

      def refuse_team
        raise StandardError if params['counter'].to_i.zero?

        render json: { 'exceeded_attempts' => check_refuse,
                       'attempts' => session[:refuse_team] },
               status: :ok
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        render json: { 'exceeded_attempts' => 'error' }, status: :internal_server_error
      end

      def refuse_order
        order = Order.find_by_order_number(refuse_params['order_number'])

        update_refuse_status!(order)

        redirect_to employee_panel_operator_dashboard_index_path,
                    notice: t('messages.successes.order.refused_successfully',
                              order_number: order.order_number)
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        redirect_to employee_panel_operator_dashboard_index_path,
                    alert: t('messages.errors.order.refuse_failed')
      end

      def confirm_order
        Builders::Mission.new(params['mission_info']).mount!

        redirect_to employee_panel_operator_dashboard_index_path,
                    notice: t('messages.successes.order.created_mission_successfully')
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        redirect_to employee_panel_operator_dashboard_index_path,
                    alert: t('messages.errors.order.create_mission_failed')
      end

      private

      def reason
        raise StandardError unless refuse_params['reason']

        t('messages.infos.refuse_reason', reason: refuse_params['reason'], employee: employee_name)
      end

      def order
        @order ||= Order.find_by_order_number(session[:order_number])
      end

      def escort_service
        @escort_service ||= EscortService.find_by_order_number(params['order_number'])
      end

      def update_blocking_status!
        order.update(
          status: Status.find_by_name('bloqueado'),
          reason: t('messages.infos.blocking_reason', employee_name: employee_name)
        )
      end

      def update_refuse_status!(order)
        order.update!(status: Status.find_by_name('cancelada'), reason: reason)
      end

      def employee_name
        ServiceToken.find_by_token(session[:employee_token]).employee.name
      end

      def send_block_notification!
        Notifications::Order.warn_about_blocking(
          order_number: order.order_number,
          blocking_date: order.updated_at,
          employee_token: session[:employee_token]
        ).deliver_now!
      end

      def check_refuse
        exceeded_attempts = false

        case session[:refuse_team]
        when nil                    then session[:refuse_team] = params['counter'].to_i
        when Order::ALLOWED_REFUSES then session[:refuse_team] = nil
                                         exceeded_attempts = true
        else                             session[:refuse_team] += params['counter'].to_i
        end

        exceeded_attempts
      end

      def team_params
        params
          .require(:agent)
          .permit(:quantity)
      end

      def refuse_params
        params
          .require(:refuse_info)
          .permit(:order_number, :reason)
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
