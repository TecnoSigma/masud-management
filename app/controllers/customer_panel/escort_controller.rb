#frozen_string_literal: true

class CustomerPanel::EscortController < PanelsController
  def list
    @orders = customer
      .escorts
      .paginate(per_page: Order::PER_PAGE_IN_CUSTOMER_DASHBOARD,
                page: params[:page])
  end

  private

  def customer
    @customer ||= ServiceToken.find_by_token(session[:customer_token]).customer
  end
end
