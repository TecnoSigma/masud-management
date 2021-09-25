# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery

  def rescue_unauthorized_error
    render file: "#{public_error_path}/401.html.erb"
  end

  def rescue_internal_server_error
    render file: "#{public_error_path}/500.html.erb"
  end

  def reset_sessions
    session.delete(:customer_token)
    session.delete(:employee_token)
    session.delete(:user_type)
  end

  private

  def public_error_path
    "#{Rails.root}/app/views/error_pages"
  end
end
