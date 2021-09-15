class Documents::Distract < ApplicationMailer
  def send_document(user)
    @seller = user
    @subscriber = user
    @user = user

    attachments["distrato-#{user.code}.pdf"] = WickedPdf.new.pdf_from_string(render_to_string(
      pdf: t('documents.seller.distract.title'),
      template: 'dashboards/sellers/informations/documents/distract.html.erb',
      layout: 'seller_distract.html')
    )

    attachments.inline['header_background.png'] = { data: File.read(Rails.root.join('app/assets/images/header_background.png')),
                                                    mime_type: 'image/png' }

    attachments.inline['footer_background.png'] = { data: File.read(Rails.root.join('app/assets/images/footer_background.png')),
                                                    mime_type: 'image/png' }

    mail to: user.email,
         subject: t('documents.send_document.subject')
  end
end
