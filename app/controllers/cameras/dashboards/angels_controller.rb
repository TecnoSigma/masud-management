class Cameras::Dashboards::AngelsController < ApplicationController
  before_action :validate_angel_session, except: [:login]

  def index; end

  def driver
    @driver = Driver.find(session[:driver]['id'])
  end

  def login
    reset_session
  end

  def logout
    reset_session

    redirect_to cameras_dashboards_angels_login_path
  end
end
