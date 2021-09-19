# frozen_string_literal: true

class EmployeePanelController < PanelsController
  helper_method :authorized_profile?

  def main; end

  def logout
    reset_session

    redirect_to employee_panel_login_path
  end

  def authorized_profile?(profile)
    session[:employee_profiles]
      .include?(Profile.find_by_kind(profile.to_s).kind)
  end
end
