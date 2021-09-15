class Cameras::LoginsController < ApplicationController
  def index; end

  def driver_names
    render json: sorted_licenses, status: :ok
  rescue StandardError
    render json: [], status: :ok
  end

  def validate_angels_access
    if verify_recaptcha && allowed_angel_access?
      redirect_to cameras_dashboards_angels_path
    else
      reset_session

      # TODO: Não existe rota nesse trecho
      redirect_to cameras_logins_angels_path,
                  alert: I18n.t('messages.errors.incorrect_data')
    end
  rescue => e
    Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")

    redirect_to cameras_logins_angels_path,
                alert: I18n.t('messages.errors.access_dashboard_failed')
  end

  def validate_drivers_access
    if verify_recaptcha && allowed_driver_access?
      redirect_to cameras_dashboards_motoristas_path
    else
      reset_session

      redirect_to cameras_dashboards_motoristas_login_path,
                  alert: I18n.t('messages.errors.incorrect_data')
    end
  rescue => e
    Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")

    redirect_to cameras_dashboards_motoristas_login_path,
                alert: I18n.t('messages.errors.access_dashboard_failed')
  end

  private

    def allowed_angel_access?
      session[:angel] = Angel.find_by_cpf(angel_params[:document])
      session[:driver] = Driver.find_by_license(angel_params[:driver])

      session[:angel].present?
    end

    def allowed_driver_access?
      session[:driver] = Driver.find_by_license(driver_params[:driver_license])
      session[:vehicle] = Vehicle.find_by_license_plate(driver_params[:license_plate])

      session[:driver].present? && session[:vehicle].present?
    end

    def angel_params
      params.require(:angel).permit(:document, :driver)
    end

    def driver_params
      params.require(:driver).permit(:driver_license, :license_plate)
    end

    def sorted_licenses
      angel = Angel.find_by_cpf(params['angel_document'])

      angel.drivers.licenses.sort { |x,y| x[1] <=> y[1] }
    end
end
