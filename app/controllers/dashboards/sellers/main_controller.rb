class Dashboards::Sellers::MainController < ApplicationController
  before_action :validate_seller_session, :find_seller

  def index; end

  def logout
    reset_session

    redirect_to login_representantes_path
  end
end
