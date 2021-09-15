class Dashboards::Sellers::Finance::ReceiptsController < ApplicationController
  before_action :validate_seller_session, :find_seller

  def index; end

  def generate_receipt
    @receipt = @seller
                 .receipts
                 .where(period: receipt_params[:period])
                 .first

    respond_to do |format|
      format.pdf do
        render Documents
                 .render_pdf(filename: t('documents.seller.receipt.title'),
                             template: 'dashboards/sellers/finance/receipts/receipt.html.erb',
                             layout: 'seller_receipt.html')
      end
    end
  end

  private
    def receipt_params
      params.require(:receipt).permit(:period)
    end
end
