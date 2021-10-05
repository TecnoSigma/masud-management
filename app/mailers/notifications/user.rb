# frozen_string_literal: true

module Notifications
  class User < ApplicationMailer
    def forgot_your_password(email:, password:)
      @password = password

      attachments.inline['logotype.jpeg'] = {
        data: File.read(Rails.root.join('app/assets/images/logotype.jpeg')),
        mime_type: 'image/jpeg'
      }

      mail to: email,
           subject: t('notifications.user.forgot_your_password.subject')
    end
  end
end
