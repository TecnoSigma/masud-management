# frozen_string_literal: true

class PanelsController < ApplicationController
  before_action :check_token, only: [:main]
  before_action :check_authorization, except: %i[login logout check_credentials]

  def login; end

  def check_credentials
    raise UserNotFound unless user
    raise UnauthorizedUser unless user.active?

    create_sessions

    redirect_to send("#{user_type}_panel_main_path")
  rescue UserNotFound, UnauthorizedUser => error
    redirect_to send("#{user_type}_panel_login_path"),
                alert: error_message(error.class)
  end

  private

  def create_sessions
    session["#{user_type}_token".to_sym] = SecureRandom.uuid
    session[:user_type] = user_type

    if user.respond_to?(:profiles)
      session[:employee_profiles] = user.profiles.map { |profile| profile.kind }
    end
  end

  def check_token
    redirect_to send("#{session[:user_type]}_panel_login_path") unless tokenized?
  end

  def tokenized?
    session["#{session[:user_type]}_token".to_sym].present?
  end

  def error_message(error)
    return t('messages.errors.incorrect_user_data') if error == UserNotFound
    return t('messages.errors.unauthorized_user') if error == UnauthorizedUser
  end

  def user_params
    params
      .require(user_type.to_sym)
      .permit(:email, :password)
  end

  def user_type
    return 'customer' if params['customer']
    return 'employee' if params['employee']
  end

  def user
    @user ||= user_type.titleize.constantize.find_by(user_params)
  end

  def check_authorization
    raise UnauthorizedUser unless authorized?
  rescue UnauthorizedUser => error
    redirect_to send("#{session[:user_type]}_panel_login_path"),
                alert: error_message(error.class)
  end

  def authorized?
    params['controller'].starts_with?(session[:user_type])
  end
end
