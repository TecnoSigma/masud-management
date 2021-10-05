# frozen_string_literal: true

class PanelsController < ApplicationController
  before_action :check_token, only: [:main]
  before_action :reset_sessions, only: [:login]
  before_action :check_authorization,
                except: %i[index
                           login
                           logout
                           check_credentials
                           change_password
                           update_password
                           forgot_your_password
                           send_password]

  def index; end

  def change_password; end

  def login; end

  def forgot_your_password; end

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

  def send_password
    customer = Customer.find_by_email(user_password_params[:email])
    employee = Employee.find_by_email(user_password_params[:email])

    user = customer || employee

    @type = 'cliente' if customer
    @type = 'gestao' if employee

    raise FindUserError unless user

    Notifications::User
      .forgot_your_password(email: user.email, password: user.password)
      .deliver_now!

    redirect_to "/#{@type}/esqueceu_sua_senha",
                notice: t('messages.successes.password_sent_successfully')
  rescue FindUserError, StandardError => error
    error_message = case error.class
                    when FindUserError
                      t('messages.errors.user_not_found')
                    when StandardError
                      t('messages.errors.send_password_failed')
                    else
                      t('messages.errors.send_password_failed')
                    end

    if error.class == StandardError
      Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")
    end

    redirect_to root_path, alert: error_message
  end

  def update_password
    @user = 'cliente' if params['customer_password']
    @user = 'gestao' if params['employee_password']

    raise ComparePasswordsError if same_passwords?
    raise StrongPasswordError unless good_password?

    if params['customer_password']
      update_password!(Customer, @user)
    elsif params['employee_password']
      update_password!(Employee, @user)
    else
      raise StandardError
    end
  rescue ComparePasswordsError, StrongPasswordError, StandardError => error
    password_error(error.class, @user)
  end

  private

  def update_password!(user_class, user)
    user_class
      .find_by(
        email: user_new_password_params[:email],
        password: user_new_password_params[:current_password]
      )
      .update(password: user_new_password_params[:new_password])

    redirect_to "/#{user}/dashboard/trocar_senha",
                notice: t('messages.successes.password_changed_successfully')
  rescue StandardError => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to "/#{user}/dashboard/trocar_senha",
                alert: t('messages.errors.change_password_failed')
  end

  def password_error(error, user)
    if error == ComparePasswordsError
      redirect_to "/#{user}/dashboard/trocar_senha", alert: t('messages.errors.same_passwords')
    end

    if error == StrongPasswordError
      redirect_to "/#{user}/dashboard/trocar_senha", alert: t('messages.errors.weak_password')
    end
  end

  def good_password?
    strength = PasswordStrength.test('', user_new_password_params[:new_password])

    return false unless strength.valid?

    strength.good? || strength.strong?
  end

  def same_passwords?
    user_new_password_params[:current_password] == user_new_password_params[:new_password]
  end

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

  def user_password_params
    params.require(:user).permit(:email)
  end

  def user_new_password_params
    user = if params['customer_password']
             params.require(:customer_password)
           elsif params['employee_password']
             params.require(:employee_password)
           end

    user.permit(:email, :current_password, :new_password)
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
