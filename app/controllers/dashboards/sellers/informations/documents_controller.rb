class Dashboards::Sellers::Informations::DocumentsController < ApplicationController
  before_action :validate_seller_session, :find_seller

  def index; end

  def contract
    respond_to do |format|
      format.pdf do
        render Documents
                 .render_pdf(filename: t('documents.seller.contract.title'),
                             template: 'dashboards/sellers/informations/documents/contract.html.erb',
                             layout: 'seller_contract.html')
      end
    end
  end

  def distract
    respond_to do |format|
      format.pdf do
        render Documents
                 .render_pdf(filename: t('documents.seller.distract.title'),
                             template: 'dashboards/sellers/informations/documents/distract.html.erb',
                             layout: 'seller_distract.html')
      end
    end
  end
end

