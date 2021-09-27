#frozen_string_literal: true

class CustomerPanel::EscortController < PanelsController
  def list
    @orders = customer.escorts
  end

  private

  def customer
    @customer ||= ServiceToken.find_by_token(session[:customer_token]).customer
  end
end
