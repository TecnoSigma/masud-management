# frozen_string_literal: true

class PanelsController < ApplicationController
  before_action :check_token, only: [:main]
  before_action :check_authorization, except: %i[index login logout check_credentials]
  before_action :reset_sessions, only: [:login]

  def index; end

  def login; end

  def check_credentials
    raise UserNotFound unless user
    raise UnauthorizedUser unless user.active?

    create_token
    create_sessions

    redirect_to send("#{user_type}_panel_dashboard_index_path")
  rescue UserNotFound, UnauthorizedUser => error
    redirect_to send("#{user_type}_panel_login_path"),
                alert: error_message(error.class)
  end

  private

  def create_token
    service_token = user.service_token
    new_token = SecureRandom.uuid

    if service_token
      service_token.update(token: new_token)
    else
      user.update(service_token: ServiceToken.create(token: new_token))
    end
  end

  def create_sessions
    session["#{user_type}_token".to_sym] = user.service_token.token
    session[:user_type] = user_type

    session[:employee_profile] = user.type if user.respond_to?(:type)
  end

  def check_token
    redirect_to root_path unless tokenized?
  end

  def tokenized?
    session["#{session[:user_type]}_token".to_sym] == user.service_token.token
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
