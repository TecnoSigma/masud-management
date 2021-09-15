#TODO CRIAR OPÇÃO PARA O PASSAGEIRO MANDAR O LINK PARA O ANGEL E GERE O FEEDBACK PARA O MOTORISTA
class Cameras::Dashboards::DriversController < ApplicationController
  before_action :validate_driver_session, except: [:login]

  def index; end
  def transmission; end

  def qrcode
    @driver = Driver.find(session[:driver]['id'])
  end

  def login
    reset_session
  end

  def logout
    reset_session

    redirect_to cameras_dashboards_motoristas_login_path
  end
end
