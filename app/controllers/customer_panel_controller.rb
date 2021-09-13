class CustomerPanelController < ApplicationController
  before_action :check_authorization, except: [:login, :check_credentials]

  def login; end
  def index; end

  def check_credentials
    raise CustomerNotFound unless customer

    check_authorization

    session[:customer_token] = SecureRandom.uuid

    redirect_to customer_panel_index_path
  rescue CustomerNotFound, UnauthorizedCustomer => error
    redirect_to customer_panel_login_path, alert: error_message(error.class)
  end

  private

  def error_message(error)
    return t('messages.errors.incorrect_customer_data') if error == CustomerNotFound
    return t('messages.errors.unauthorized_customer') if error == UnauthorizedCustomer
  end

  def customer_params
    params
      .require(:customer)
      .permit(:email, :password)
  end

  def customer
    @customer ||= Customer.find_by(customer_params)
  end

  def check_authorization
    raise UnauthorizedCustomer unless customer.active?
  end
end
