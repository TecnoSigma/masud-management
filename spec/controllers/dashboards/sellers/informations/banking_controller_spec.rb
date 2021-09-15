require 'rails_helper'

RSpec.describe Dashboards::Sellers::Informations::BankingController, type: :controller do
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

    describe '#edit' do
      it 'returns http status code 200 when exist seller session' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        session[:seller_code] = seller.code

        get :edit

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when no exist seller session' do
        get :edit

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'PUT actions' do
    describe '#update' do
      it 'returns http status code 302 when exist seller session' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        session[:seller_code] = seller.code

        bank = FactoryBot.create(:bank)
        account = FactoryBot.create(:account, bank: bank, seller: seller)

        new_bank = FactoryBot.create(:bank, name: 'Banco ABC S.A.')
        new_agency = '12000-Z'
        new_account = '9999-B'

        put :update, params: { seller: { bank: new_bank.compe_register, agency: new_agency, account: new_account } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when no exist seller session' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        bank = FactoryBot.create(:bank)
        account = FactoryBot.create(:account, bank: bank, seller: seller)

        new_bank = FactoryBot.create(:bank, name: 'Banco ABC S.A.')
        new_agency = '12000-Z'
        new_account = '9999-B'

        put :update, params: { seller: { bank: new_bank.compe_register, agency: new_agency, account: new_account } }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST actions' do
    describe '#create' do
      it 'returns http status code 302 when exist seller session' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        session[:seller_code] = seller.code

        bank = FactoryBot.create(:bank)

        new_bank = FactoryBot.create(:bank, name: 'Banco ABC S.A.')
        new_agency = '12000-Z'
        new_account = '9999-B'

        post :create, params: { seller: { bank: new_bank.compe_register, agency: new_agency, account: new_account } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when no exist seller session' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        bank = FactoryBot.create(:bank)

        new_bank = FactoryBot.create(:bank, name: 'Banco ABC S.A.')
        new_agency = '12000-Z'
        new_account = '9999-B'

        post :create, params: { seller: { bank: new_bank.compe_register, agency: new_agency, account: new_account } }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#create' do
    it 'creates seller account when pass valid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)

      new_agency = '12000-Z'
      new_account = '9999-B'

      post :create, params: { seller: { bank: bank.compe_register, agency: new_agency, account: new_account } }

      result = Seller.find_by_code(session[:seller_code])

      expect(result.bank).to eq(bank)
      expect(result.account.agency).to eq(new_agency)
      expect(result.account.number).to eq(new_account)
    end

    it 'redirects to seller account dashboard when pass valid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)

      new_agency = '12000-Z'
      new_account = '9999-B'

      post :create, params: { seller: { bank: bank.compe_register, agency: new_agency, account: new_account } }

      expect(response).to redirect_to(dashboards_representantes_informacoes_pessoais_dados_bancarios_path)
    end

    it 'shows success message when pass valid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)

      new_agency = '12000-Z'
      new_account = '9999-B'

      post :create, params: { seller: { bank: bank.compe_register, agency: new_agency, account: new_account } }

      expect(flash[:notice]).to eq('Dados gravados com sucesso!')
    end

    it 'no updates account data when pass invalid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)

      new_account = '9999-B'

      post :create, params: { seller: { bank: bank.compe_register, agency: nil, account: new_account } }

      result = Account.find_by_number(new_account)

      expect(result).to be_nil
    end

    it 'redirects to seller account dashboard when pass invalid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)

      new_account = '9999-B'

      post :create, params: { seller: { bank: bank.compe_register, agency: nil, account: new_account } }

      expect(response).to redirect_to(dashboards_representantes_informacoes_pessoais_dados_bancarios_path)
    end

    it 'shows error message when pass invalid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)

      new_account = '9999-B'

      post :create, params: { seller: { bank: bank.compe_register, agency: nil, account: new_account } }

      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end

    it 'redirects to seller account dashboard when occurs errors' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)

      new_agency = '12000-Z'
      new_account = '9999-B'

      allow(Bank).to receive(:find_by_compe_register) { raise StandardError }

      post :create, params: { seller: { bank: bank.compe_register, agency: new_agency, account: new_account } }

      expect(response).to redirect_to(dashboards_representantes_informacoes_pessoais_dados_bancarios_path)
    end

    it 'shows error message when occurs errors' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)

      new_agency = '12000-Z'
      new_account = '9999-B'

      allow(Bank).to receive(:find_by_compe_register) { raise StandardError }

      post :create, params: { seller: { bank: bank.compe_register, agency: new_agency, account: new_account } }

      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end
  end


  describe '#update' do
    it 'updates account data when pass valid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)
      account = FactoryBot.create(:account, bank: bank, seller: seller)

      new_bank = FactoryBot.create(:bank, compe_register: '111', name: 'Banco ABC S.A.')
      new_agency = '12000-Z'
      new_account = '9999-B'

      put :update, params: { seller: { bank: new_bank.compe_register, agency: new_agency, account: new_account } }

      result = Seller.find_by_code(session[:seller_code])

      expect(result.bank).to eq(new_bank)
      expect(result.account.agency).to eq(new_agency)
      expect(result.account.number).to eq(new_account)
    end

    it 'redirects to seller account dashboard when pass valid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)
      account = FactoryBot.create(:account, bank: bank, seller: seller)

      new_bank = FactoryBot.create(:bank, name: 'Banco ABC S.A.')
      new_agency = '12000-Z'
      new_account = '9999-B'

      put :update, params: { seller: { bank: new_bank.compe_register, agency: new_agency, account: new_account } }

      expect(response).to redirect_to(dashboards_representantes_informacoes_pessoais_dados_bancarios_path)
    end

    it 'shows success message when pass valid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)
      account = FactoryBot.create(:account, bank: bank, seller: seller)

      new_bank = FactoryBot.create(:bank, name: 'Banco ABC S.A.')
      new_agency = '12000-Z'
      new_account = '9999-B'

      put :update, params: { seller: { bank: new_bank.compe_register, agency: new_agency, account: new_account } }

      expect(flash[:notice]).to eq('Dados atualizados com sucesso!')
    end

    it 'no updates account data when pass invalid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)
      account = FactoryBot.create(:account, bank: bank, seller: seller)

      new_bank = FactoryBot.create(:bank, name: 'Banco ABC S.A.')
      new_account = '9999-B'

      put :update, params: { seller: { bank: new_bank.compe_register, agency: nil, account: new_account } }

      result = Seller.find_by_code(session[:seller_code])

      expect(result.bank).to eq(bank)
      expect(result.account.agency).to eq(account.agency)
      expect(result.account.number).to eq(account.number)
    end

    it 'redirects to seller account dashboard when pass invalid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)
      account = FactoryBot.create(:account, bank: bank, seller: seller)

      new_bank = FactoryBot.create(:bank, name: 'Banco ABC S.A.')
      new_account = '9999-B'

      put :update, params: { seller: { bank: new_bank.compe_register, agency: nil, account: new_account } }

      result = Seller.find_by_code(session[:seller_code])

      expect(response).to redirect_to(dashboards_representantes_informacoes_pessoais_dados_bancarios_path)
    end

    it 'shows error message when pass invalid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      bank = FactoryBot.create(:bank)
      account = FactoryBot.create(:account, bank: bank, seller: seller)

      new_bank = FactoryBot.create(:bank, name: 'Banco ABC S.A.')
      new_account = '9999-B'

      put :update, params: { seller: { bank: new_bank.compe_register, agency: nil, account: new_account } }

      result = Seller.find_by_code(session[:seller_code])

      expect(flash[:alert]).to eq('Falha ao atualizar dados!')
    end

    it 'redirects to seller account dashboard when occurs errors' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      put :update, params: { seller: { bank: 'anything', agency: 'anything', account: 'anything' } }

      result = Seller.find_by_code(session[:seller_code])

      expect(response).to redirect_to(dashboards_representantes_informacoes_pessoais_dados_bancarios_path)
    end

    it 'shows error message when occurs errors' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      put :update, params: { seller: { bank: 'anything', agency: 'anything', account: 'anything' } }

      result = Seller.find_by_code(session[:seller_code])

      expect(flash[:alert]).to eq('Falha ao atualizar dados!')
    end
  end

  describe '#index' do
    it 'assigns variable containing seller data' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      get :index

      expect(assigns[:seller]).to eq(seller)
    end
  end

  describe '#edit' do
    it 'assigns variable containing seller data' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      get :edit

      expect(assigns[:seller]).to eq(seller)
    end
  end
end
