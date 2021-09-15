class Dashboards::Sellers::Finance::SalesController < ApplicationController
  before_action :validate_seller_session, :find_seller

  def index
    @orders = @seller
                .orders
                .paginate(page: params[:page], per_page: Order::PAGINATE)
  end
end
