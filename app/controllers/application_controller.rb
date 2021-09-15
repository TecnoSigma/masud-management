class ApplicationController < ActionController::Base
  def validate_sessions
    redirect_to login_assinantes_path unless session[:subscriber_code]
  end

  def validate_seller_session
    redirect_to login_representantes_path unless session[:seller_code]
  end

  def validate_driver_session
    redirect_to cameras_dashboards_motoristas_login_path unless session[:driver]
  end

  def validate_angel_session
    redirect_to cameras_dashboards_angels_login_path unless session[:angel]
  end

  def find_subscriber
    @subscriber ||= Subscriber.find_by_code(session[:subscriber_code])
  end

  def find_seller
    @seller ||= Seller.find_by_code(session[:seller_code])
  end
end
