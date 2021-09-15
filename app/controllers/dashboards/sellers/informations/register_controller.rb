class Dashboards::Sellers::Informations::RegisterController < ApplicationController
  before_action :validate_seller_session, :find_seller

  def index; end
  def edit; end

  def update
    seller = Seller.find_by_code(session[:seller_code])

    message = if seller.update_attributes!(seller_params)
                { notice: t('messages.successes.update_data') }
              else
                { alert: t('messages.errors.update_data_failed') }
              end

    redirect_to dashboards_representantes_informacoes_pessoais_cadastro_path, message
  rescue => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to dashboards_representantes_informacoes_pessoais_cadastro_path,
                alert: t('messages.errors.update_data_failed')
  end

  private

    def seller_params
      params
        .require(:seller)
        .permit(:name,
                :core_register,
                :expedition_date,
                :expiration_date,
                :cellphone,
                :email,
                :address,
                :number,
                :complement,
                :district,
                :city,
                :state,
                :linkedin,
                :postal_code)
   end
end
