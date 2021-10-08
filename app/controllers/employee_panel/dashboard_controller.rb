# frozen_string_literal: true

module EmployeePanel
  class DashboardController < PanelsController
    before_action :router, only: [:index]

    def index ; end

    private

    def router
      redirect_to send("employee_panel_#{profile}_dashboard_index_path")
    rescue StandardError => error
      Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

      redirect_to employee_panel_login_path
    end

    def profile
      @profile ||= session[:employee_profile].downcase
    end
  end
end
