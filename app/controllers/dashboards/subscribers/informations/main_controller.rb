class Dashboards::Subscribers::Informations::MainController < ApplicationController
  before_action :validate_sessions, :find_subscriber

  def index; end
end
