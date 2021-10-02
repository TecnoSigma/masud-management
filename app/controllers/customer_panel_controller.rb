# frozen_string_literal: true

class CustomerPanelController < PanelsController
  def dashboard; end

  def logout
    reset_session

    redirect_to customer_panel_login_path
  end

  def cities
    cities = State
             .find_by_name(params['state_name'])
             .cities
             .all
             .map(&:name)
             .sort

    render json: { 'cities' => cities }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")

    render json: { 'cities' => [] }, status: :internal_server_error
  end
end
