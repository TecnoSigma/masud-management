class Dashboards::Subscribers::MainController < ApplicationController
  before_action :validate_sessions, :find_subscriber

  def index; end

  def logout
    reset_session

    redirect_to login_assinantes_path
  end
end
