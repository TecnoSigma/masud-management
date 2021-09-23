# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery

  def reset_sessions
    session.delete(:customer_token)
    session.delete(:employee_token)
    session.delete(:user_type)
  end
end
