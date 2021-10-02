# frozen_string_literal: true

class EmployeePanelController < PanelsController
  before_action :router, only: [:main]

  def main; end

  def logout
    reset_session

    redirect_to employee_panel_login_path
  end

  private

  def check_internal_profile(controller)
    return if Employee::MASTER_PROFILE == profile

    authorized = controller
                 .split('/')
                 .last
                 .start_with?(profile.downcase)

    rescue_unauthorized_error unless authorized
  rescue StandardError => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    rescue_internal_server_error
  end

  def router
    redirect_to send("employee_panel_#{profile}_dashboard_path")
  rescue StandardError
    redirect_to employee_panel_login_path
  end

  def profile
    @profile ||= session[:employee_profile].downcase
  end
end
