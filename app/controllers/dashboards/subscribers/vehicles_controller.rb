class Dashboards::Subscribers::VehiclesController < ApplicationController
  before_action :validate_sessions
  before_action :find_subscriber

  def index; end

  def add_photos
    @vehicle = @subscriber.vehicles.find(params['vehicle_id'])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboards_assinantes_veiculos_path,
                alert: t('messages.errors.search_data_failed')
  end

  def upload_photos
    if vehicle
      vehicle.photos.attach(vehicle_params[:photos])

      redirect_to dashboards_assinantes_veiculos_path,
                  notice: t('messages.successes.save_data')
    else
      redirect_to dashboards_assinantes_veiculos_path,
                  alert: t('messages.errors.search_data_failed')
    end
  rescue => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to dashboards_assinantes_veiculos_path,
                alert: t('messages.errors.save_data_failed')
  end

  def details
    if vehicle
      @vehicle = vehicle
    else
      redirect_to dashboards_assinantes_veiculos_path,
                  alert: t('messages.errors.search_data_failed')
    end
  rescue => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to dashboards_assinantes_veiculos_path,
                alert: t('messages.errors.show_data_failed')
  end

  private
    def vehicle
      vehicle_id = params['vehicle_id'] || vehicle_params[:id]

      vehicle ||= @subscriber
                    .vehicles
                    .detect { |vehicle| vehicle.id.to_s == vehicle_id }
    end

    def vehicle_params
      params.require(:vehicle).permit(:id, photos: [])
    end
end
