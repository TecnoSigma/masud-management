class Dashboards::Sellers::Informations::MainController < ApplicationController
  before_action :validate_seller_session, :find_seller

  def index; end
end
