class HomeController < ApplicationController
  def index; end
  def seller; end
  def hire_seller; end

  def hire
    session[:plan] = { code: params['plan']['code'],
                       name: params['plan']['name'],
                       price: params['plan']['price'] }

    redirect_to checkout_identificacao_path
  end

  def chart_data
    render json: CHART_DATA, status: :ok
  end

  def create_seller
    seller = Seller.new(seller_params)

    if seller.valid? && seller.save!
      redirect_to home_representantes_path,
                  notice: t('messages.successes.created_seller')
    else
      redirect_to home_representantes_contratar_path,
                  alert: t('messages.errors.save_data_failed')
    end
  rescue => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to home_representantes_contratar_path,
                alert: t('messages.errors.save_data_failed')
  end

  def seller_contract
    respond_to do |format|
      format.pdf do
        render Documents
                 .render_pdf(filename: t('documents.seller.contract.title'),
                             template: 'dashboards/sellers/informations/documents/contract.html.erb',
                             layout: 'seller_contract.html')
      end
    end
  end

  def contract
    respond_to do |format|
      format.pdf do
        render Documents
                 .render_pdf(filename: t('documents.subscriber.contract.title'),
                             template: 'dashboards/subscribers/informations/documents/contract.html.erb',
                             layout: 'subscriber_contract.html')
      end
    end
  end

  private
    def seller_params
      params
        .require(:new_seller)
        .permit(:name,
                :core_register,
                :expedition_date,
                :expiration_date,
                :password,
                :document,
                :cellphone,
                :email,
                :linkedin,
                :address,
                :number,
                :complement,
                :district,
                :city,
                :state,
                :postal_code)
        .merge!({ code: Seller.generate_code(params['new_seller']['document']),
                  password: Seller.generate_password })
   end
end
