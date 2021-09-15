# frozen_string_literal: true

class EmployeePanelController < ApplicationController
  before_action :check_token, only: [:main]

  def login; end

  def main; end

  def check_credentials
    raise EmployeeNotFound unless employee
    raise UnauthorizedEmployee unless employee.active?

    session[:employee_token] = SecureRandom.uuid

    redirect_to employee_panel_main_path
  rescue EmployeeNotFound, UnauthorizedEmployee => error
    redirect_to employee_panel_login_path, alert: error_message(error.class)
  end

  private

  def check_token
    redirect_to employee_panel_login_path unless tokenized?
  end

  def tokenized?
    session[:employee_token].present?
  end

  def error_message(error)
    return t('messages.errors.incorrect_user_data') if error == EmployeeNotFound
    return t('messages.errors.unauthorized_user') if error == UnauthorizedEmployee
  end

  def employee_params
    params
      .require(:employee)
      .permit(:email, :password)
  end

  def employee
    @employee ||= Employee.find_by(employee_params)
  end
end
