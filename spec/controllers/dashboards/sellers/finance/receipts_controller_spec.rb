require 'rails_helper'

RSpec.describe Dashboards::Sellers::Finance::ReceiptsController do
  describe 'GET actions' do
    describe '#index' do
      it 'returns http status code 200 when exist seller session' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        session[:seller_code] = seller.code

        get :index

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when no exist seller session' do
        get :index

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST actions' do
    describe '#generate_receipt' do
      it 'returns http status code 200 when exist seller session' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        session[:seller_code] = seller.code

        period = 'Maio/2020'

        post :generate_receipt, params: { receipt: { period: period } }, format: :pdf

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when no exist seller session' do
        period = 'Maio/2020'

        post :generate_receipt, params: { receipt: { period: period } }, format: :pdf

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#generate_receipt' do
    it 'assigns variable with receipt data when pass valid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      subscriber = FactoryBot.create(:subscriber)
      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      order = FactoryBot.create(:order,
                                subscription: subscription,
                                price: 5340.12,
                                seller: seller,
                                status: 'aprovado',
                                approved_at: DateTime.parse('31-01-2020'))

      period = 'Janeiro/2020'
      credits = { services: 2347.45 }
      debits = { inss: 234.40, irrf: 23.40 }

      receipt = FactoryBot.create(:receipt, credits: credits, debits: debits, period: period, seller: seller)

      post :generate_receipt, params: { receipt: { period: period } },  format: :pdf

      expect(assigns[:receipt]).to eq(receipt)
    end

    it 'no assigns variable with receipt data when pass valid params and no exist receipts' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      subscriber = FactoryBot.create(:subscriber)
      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      order = FactoryBot.create(:order,
                                subscription: subscription,
                                price: 5340.12,
                                seller: seller,
                                status: 'aprovado',
                                approved_at: DateTime.parse('31-01-2020'))

      period = 'Janeiro/2020'
      credits = { services: 2347.45 }
      debits = { inss: 234.40, irrf: 23.40 }

      other_period = 'Maio/2020'

      receipt = FactoryBot.create(:receipt, credits: credits, debits: debits, period: period, seller: seller)

      post :generate_receipt, params: { receipt: { period: other_period } },  format: :pdf

      expect(assigns[:receipt]).to be_nil
    end

  end
end
