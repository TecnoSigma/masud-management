class SubscriberLoginsController < LoginsController
  def send_subscriber_password
    send_password(:subscriber, password_params)
  end

  def validate_subscriber_access
    subscriber = Subscriber
                   .active
                   .where(user: subscriber_params[:user],
                          password: subscriber_params[:password])
                   .first

    if verify_recaptcha && subscriber.present?
      session[:subscriber_code] = subscriber.code

      redirect_to dashboards_assinantes_path
    else
      redirect_to login_assinantes_path,
                  alert: t('messages.errors.access_dashboard_failed')
    end
  end

  private

    def subscriber_params
      params.require(:subscriber).permit(:user, :password)
    end

    def password_params
      params.require(:password).require(:document)
    end
end
