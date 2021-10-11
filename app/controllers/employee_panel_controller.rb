# frozen_string_literal: true

class EmployeePanelController < PanelsController
  def logout
    reset_session

    redirect_to employee_panel_login_path
  end

  private

  def check_internal_profile(controller)
    return if Employee::MASTER_PROFILE.downcase == profile

    authorized = controller.split('/').drop(1)
                           .first.split('_').first
                           .start_with?(profile.downcase)

    rescue_unauthorized_error unless authorized
  rescue StandardError => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    rescue_internal_server_error
  end

  def profile
    @profile ||= session[:employee_profile].downcase
  end
end
