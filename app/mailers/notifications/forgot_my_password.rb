class Notifications::ForgotMyPassword < ApplicationMailer
  def send_password(user)
    @name = user.try(:responsible_name) || user.name
    @password = user.password

    attachments.inline['header_background.png'] = { data: File.read(Rails.root.join('app/assets/images/header_background.png')),
                                                    mime_type: 'image/png' }

    attachments.inline['footer_background.png'] = { data: File.read(Rails.root.join('app/assets/images/footer_background.png')),
                                                    mime_type: 'image/png' }


    mail to: user.email,
         subject: t('notifications.send_password.subject')
  end
end
