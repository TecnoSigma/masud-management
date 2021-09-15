class Dashboards::Subscribers::Informations::RegisterController < ApplicationController
  before_action :validate_sessions, :find_subscriber

  def index; end
  def edit; end

  def update
    @subscriber.assign_attributes(subscriber_params)

    if @subscriber.valid? && update_payment_gateway_data!
      @subscriber.update_attributes!(subscriber_params)

      message = { notice: t('messages.successes.update_data') }
    else
      message = { alert: t('messages.errors.update_data_failed') }
    end

    redirect_to dashboards_assinantes_informacoes_pessoais_cadastro_path, message
  rescue => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to dashboards_assinantes_informacoes_pessoais_cadastro_path,
                alert: t('messages.errors.update_data_failed')
  end

  private

  def update_payment_gateway_data!
    Gateways::Payment::Subscriber.update!(@subscriber)
  end

  def subscriber_params
    params
      .require(:subscriber)
      .permit(:responsible_name,
              :responsible_cpf,
              :postal_code,
              :address,
              :number,
              :complement,
              :district,
              :city,
              :state,
              :telephone,
              :cellphone)
      .merge('code' => session[:subscriber_code])
  end
end

