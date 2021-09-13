# frozen_string_literal: true

class CustomerPanelController < ApplicationController
  before_action :check_token, only: [:main]

  def login; end

  def main; end

  def check_credentials
    raise CustomerNotFound unless customer
    raise UnauthorizedCustomer unless customer.active?

    session[:customer_token] = SecureRandom.uuid

    redirect_to customer_panel_main_path
  rescue CustomerNotFound, UnauthorizedCustomer => error
    redirect_to customer_panel_login_path, alert: error_message(error.class)
  end

  private

  def check_token
    redirect_to customer_panel_login_path unless tokenized?
  end

  def tokenized?
    session[:customer_token].present?
  end

  def error_message(error)
    return t('messages.errors.incorrect_user_data') if error == CustomerNotFound
    return t('messages.errors.unauthorized_user') if error == UnauthorizedCustomer
  end

  def customer_params
    params
      .require(:customer)
      .permit(:email, :password)
  end

  def customer
    @customer ||= Customer.find_by(customer_params)
  end
end
