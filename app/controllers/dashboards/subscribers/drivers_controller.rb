class Dashboards::Subscribers::DriversController < ApplicationController
  before_action :validate_sessions, :find_subscriber

  def index
    @drivers = @subscriber.drivers
  end

  def insert
    @vehicles_list = @subscriber.vehicles.pluck(:license_plate)
    @driver = Driver.new
  end

  def remove
    if driver
      Driver.delete(driver.id)

      redirect_to dashboards_assinantes_motoristas_path,
                  notice: t('messages.successes.remove_data')
    else
      redirect_to dashboards_assinantes_motoristas_path,
                  alert: t('messages.errors.remove_data_failed')
    end
  rescue => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to dashboards_assinantes_motoristas_path,
                alert: t('messages.errors.remove_data_failed')
  end

  def edit
    @vehicles_list = @subscriber.vehicles.pluck(:license_plate)

    if driver
      @driver = driver
    else
      redirect_to dashboards_assinantes_motoristas_path,
                  alert: t('messages.errors.search_data_failed')
    end
  rescue => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to dashboards_assinantes_motoristas_path,
                alert: t('messages.errors.show_data_failed')
  end

  def details
    if driver
      @driver = driver
    else
      redirect_to dashboards_assinantes_motoristas_path,
                  alert: t('messages.errors.search_data_failed')
    end
  rescue => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to dashboards_assinantes_motoristas_path,
                alert: t('messages.errors.show_data_failed')
  end

  def create
    driver = Driver.new(driver_params)
    driver.code = driver.generate_code

    if driver.valid? && driver.save!
      driver.update_attributes!(vehicles: vehicles_list)
      driver.document.attach(driver_params['document'])
      driver.avatar.attach(driver_params['avatar'])

      redirect_to driver_details_path(driver.id),
                  notice: t('messages.successes.save_data')
    else
      redirect_to dashboards_assinantes_motoristas_adicionar_path,
                  alert: t('messages.errors.save_data_failed')
    end
  rescue => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to dashboards_assinantes_motoristas_adicionar_path,
                alert: t('messages.errors.save_data_failed')
  end

  def update
    driver_data = driver

    if driver_data.update_attributes!(driver_params)
      driver_data.update_attributes!(vehicles: vehicles_list) if driver_params['vehicle_license_plates']
      driver_data.document.attach(driver_params['document']) if driver_params['document']
      driver_data.avatar.attach(driver_params['avatar']) if driver_params['avatar']

      redirect_to driver_details_path(driver_data.id),
                  notice: t('messages.successes.update_data')
    else
      redirect_to edit_driver_path(driver_data.id),
                  alert: t('messages.errors.update_data_failed')
    end
  rescue => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to dashboards_assinantes_motoristas_path,
                alert: t('messages.errors.update_data_failed')
  end

  private

    def vehicles_list
      params['driver']['vehicle_license_plates']
        .reject(&:blank?)
        .map { |license_plate| Vehicle.find_by_license_plate(license_plate) }
    end

    def driver
      driver_id = params['driver_id'] || driver_params[:id] || params['driver']['driver_id']

      driver ||= @subscriber
                   .drivers
                   .detect { |driver| driver.id.to_s == driver_id }
    end

    def driver_params
      params
        .require(:driver)
        .permit(:vehicle_license_plates,
                :name,
                :license,
                :paid_activity,
                :expedition_date,
                :expiration_date,
                :document,
                :avatar)
    end
end
