class Dashboards::Sellers::Informations::BankingController < ApplicationController
  before_action :validate_seller_session, :find_seller

  def index; end
  def edit; end

  def create
    bank = Bank.find_by_compe_register(seller_params[:bank])

    account = Account
                .new(agency: seller_params[:agency],
                     number: seller_params[:account],
                     seller: @seller,
                     bank: bank)

    if account.valid? && account.save!
      redirect_to dashboards_representantes_informacoes_pessoais_dados_bancarios_path,
                  notice: t('messages.successes.save_data')
    else
      redirect_to dashboards_representantes_informacoes_pessoais_dados_bancarios_path,
                  alert: t('messages.errors.save_data_failed')
    end
  rescue => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to dashboards_representantes_informacoes_pessoais_dados_bancarios_path,
                alert: t('messages.errors.save_data_failed')
  end

  def update
    ActiveRecord::Base.transaction do
      bank = Bank.find_by_compe_register(seller_params[:bank])
      @seller.bank = bank
      @seller.save!

      account = @seller.account
      account.agency = seller_params[:agency]
      account.number = seller_params[:account]
      account.save!
    end

    redirect_to dashboards_representantes_informacoes_pessoais_dados_bancarios_path,
                notice: t('messages.successes.update_data')
  rescue => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to dashboards_representantes_informacoes_pessoais_dados_bancarios_path,
                alert: t('messages.errors.update_data_failed')
  end

  private

  def seller_params
    params.require(:seller).permit(:bank, :agency, :account)
  end
end
