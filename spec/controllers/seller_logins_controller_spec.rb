require 'rails_helper'

RSpec.describe SellerLoginsController, type: :controller do
  describe 'GET actions' do
    describe '#index' do
      it 'returns HTTP status 200' do
        get :index

        expect(response).to have_http_status(200)
      end
    end

    describe '#forgot_my_password' do
      it 'returns HTTP status 200' do
        get :forgot_my_password

        expect(response).to have_http_status(200)
      end
    end

    describe '#send_seller_password' do
      it 'returns http status code 302 when pass valid params' do
        allow(Notifications::ForgotMyPassword).to receive_message_chain(:send_password, :deliver_now) { true }

        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        post :send_seller_password, params: { password: { seller_document: seller.document } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when subscriber not found' do
        post :send_seller_password, params: { password: { seller_document: 'any_document' } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when occurs some errors' do
        allow(Seller).to receive(:find_by_document) { raise StandardError }

        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        post :send_seller_password, params: { password: { seller_document: seller.document } }

        expect(response).to have_http_status(302)
      end
    end

    describe '#validate_seller_access' do
      it 'returns http status code 302 when pass valid params' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        post :validate_seller_access, params: { seller: { document: seller.document,
                                                          password: seller.password } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when pass invalid params' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        post :validate_seller_access, params: { seller: { document: seller.document,
                                                          password: 'anything' } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when seller status isn\'t activated with valid password' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:pendent]
        seller.save!

        post :validate_seller_access, params: { seller: { document: seller.document,
                                                          password: seller.password } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when seller status isn\'t activated with invalid password' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:pendent]
        seller.save!

        post :validate_seller_access, params: { seller: { document: seller.document,
                                                          password: seller.password } }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#send_seller_password' do
    it 'redirects to login page when send password only active seller' do
      allow(Notifications::ForgotMyPassword).to receive_message_chain(:send_password, :deliver_now) { true }

      seller = FactoryBot.create(:seller, email: 'anything@gmail.com')
      seller.status = Status::STATUSES[:activated]
      seller.save!

      post :send_seller_password, params: { password: { seller_document: seller.document } }

      expect(response).to redirect_to(login_representantes_path)
    end

    it 'shows success message when send password only active seller' do
      allow(Notifications::ForgotMyPassword).to receive_message_chain(:send_password, :deliver_now) { true }

      seller = FactoryBot.create(:seller, email: 'anything@gmail.com')
      seller.status = Status::STATUSES[:activated]
      seller.save!

      post :send_seller_password, params: { password: { seller_document: seller.document } }

      expect(flash[:notice]).to eq("Senha enviada com sucesso para o email a******@gmail.com!")
    end

    it 'redirects to forgot password page when seller not found' do
      post :send_seller_password, params: { password: { document: 'any_document' } }

      expect(response).to redirect_to (login_representantes_esqueci_minha_senha_path)
    end

    it 'shows error message when seller not found' do
      post :send_seller_password, params: { password: { document: 'any_document' } }

      expect(flash[:alert]).to eq('Falha no envio da senha!')
    end

    it 'redirects to forgot password page when occurs some errors' do
      allow(Seller).to receive(:find_by_document) { raise StandardError }

      seller = FactoryBot.create(:seller, email: 'anything@gmail.com')
      seller.status = Status::STATUSES[:activated]
      seller.save!

      post :send_seller_password, params: { password: { document: seller.document } }

      expect(flash[:alert]).to eq('Falha no envio da senha!')
    end
  end

  describe '#validate_seller_access' do
    it 'redirects to dashboard page when access is allowed' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      post :validate_seller_access,
           params: { seller: { document: seller.document,
                               password: seller.password } }

      expect(response).to redirect_to(dashboards_representantes_path)
    end

    it 'redirects to login page when subscriber access isn\'t is allowed' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      post :validate_seller_access,
           params: { seller: { document: seller.document,
                               password: 'anything' } }

      expect(response).to redirect_to(login_representantes_path)
    end

    it 'shows error message when subscriber access isn\'t is allowed' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      post :validate_seller_access,
           params: { seller: { document: seller.document,
                               password: 'anything' } }

      expect(flash[:alert]).to eq('Falha no acesso ao dashboard!')
    end

    it 'creates session containing subscriber data' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      post :validate_seller_access,
           params: { seller: { document: seller.document,
                               password: seller.password } }

      expect(session[:seller_code]).to be_present
    end
  end
end
