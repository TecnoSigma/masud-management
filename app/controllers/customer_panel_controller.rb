# frozen_string_literal: true

class CustomerPanelController < PanelsController
  def main; end

  def logout
    reset_session

    redirect_to customer_panel_login_path
  end
end
