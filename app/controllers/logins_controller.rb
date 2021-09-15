class LoginsController < ApplicationController
  def index; end
  def forgot_my_password; end

  private

    def translated_user(user)
      t("#{user.to_s.pluralize}")
    end

    def send_password(user, params)
      translated_user = translated_user(user)

      user = user
               .to_s
               .titleize
               .constantize
               .find_by_document(params)

      if user.present? && user.active?
        Notifications::ForgotMyPassword.send_password(user).deliver_now

        redirect_to send("login_#{translated_user}_path"),
                    notice: t('messages.successes.password_sent',
                              subscriber_email: user.hidden_email)
      else
        redirect_to send("login_#{translated_user}_esqueci_minha_senha_path"),
                    alert: t('messages.errors.send_password_failed')
      end
    rescue => e
      Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")

      redirect_to send("login_#{translated_user}_esqueci_minha_senha_path"),
                  alert: t('messages.errors.send_password_failed')
    end

    def subscriber_params
      params.require(:subscriber).permit(:user, :password)
    end

    def password_params
      params.require(:password).require(:document)
    end
end
