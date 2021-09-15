class Dashboards::Subscribers::Informations::DocumentsController < ApplicationController
  before_action :validate_sessions, :find_subscriber

  def index;end

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

  def distract
    respond_to do |format|
      format.pdf do
        render Documents
                 .render_pdf(filename: t('documents.subscriber.distract.title'),
                             template: 'dashboards/subscribers/informations/documents/distract.html.erb',
                             layout: 'subscriber_distract.html')
      end
    end
  end
end

