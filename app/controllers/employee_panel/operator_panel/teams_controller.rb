# frozen_string_literal: true

module EmployeePanel
  module OperatorPanel
    class TeamsController < DashboardController
      def mount_team
        team = Builders::Team.mount!

        render json: { 'team' => team }, status: :ok
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        render json: { 'team' => {} }, status: :internal_server_error
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

      private

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
    end
  end
end
