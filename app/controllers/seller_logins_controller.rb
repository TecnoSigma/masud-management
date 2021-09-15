class SellerLoginsController < LoginsController
  def send_seller_password
    send_password(:seller, password_params['seller_document'])
  end

  def validate_seller_access
    seller = Seller
               .activated
               .where(document: seller_params[:document],
                      password: seller_params[:password])
               .first

    if verify_recaptcha && seller.present?
      session[:seller_code] = seller.code

      redirect_to dashboards_representantes_path
    else
      redirect_to login_representantes_path,
                  alert: t('messages.errors.access_dashboard_failed')
    end
  end

  private

    def seller_params
      params.require(:seller).permit(:document, :password)
    end

    def password_params
      params.require(:password).permit(:seller_document)
    end
end
