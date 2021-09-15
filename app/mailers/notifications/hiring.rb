class Notifications::Hiring < ApplicationMailer
  def finalization(subscriber)
    @name = subscriber['name']

    attachments.inline['header_background.png'] = { data: File.read(Rails.root.join('app/assets/images/header_background.png')),
                                                    mime_type: 'image/png' }

    attachments.inline['footer_background.png'] = { data: File.read(Rails.root.join('app/assets/images/footer_background.png')),
                                                    mime_type: 'image/png' }

    mail to: subscriber['email'],
         subject: t('notifications.hiring_finalization.subject')  
  end
end
