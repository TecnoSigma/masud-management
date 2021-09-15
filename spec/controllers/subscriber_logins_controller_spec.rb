require 'rails_helper'

RSpec.describe SubscriberLoginsController, type: :controller do
  describe 'GET actions' do
    describe '#index' do
      it 'returns HTTP status 200' do
        get :index

        expect(response).to have_http_status(200)
      end
    end

    describe '#send_subscriber_password' do
      it 'returns http status code 302 when pass valid params' do
        allow(Notifications::ForgotMyPassword).to receive_message_chain(:send_password, :deliver_now) { true }

        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        post :send_subscriber_password, params: { password: { document: subscriber.document } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when subscriber not found' do
        post :send_subscriber_password, params: { password: { document: 'any_document' } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when occurs some errors' do
        allow(Subscriber).to receive(:find_by_document) { raise StandardError }

        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        post :send_subscriber_password, params: { password: { document: subscriber.document } }

        expect(response).to have_http_status(302)
      end
    end

    describe '#validate_subscriber_access' do
      it 'returns http status code 302 when pass valid params' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        post :validate_subscriber_access, params: { subscriber: { user: subscriber.user,
                                                       password: subscriber.password } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when pass invalid params' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        post :validate_subscriber_access,
             params: { subscriber: { user: subscriber.user,
                                     password: 'anything' } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when subscriber status isn\'t activated' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:pendent]
        subscriber.save!

        post :validate_subscriber_access,
             params: { subscriber: { user: subscriber.user,
                                     password: 'anything' } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when subscriber status isn\'t activated' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:pendent]
        subscriber.save!

        post :validate_subscriber_access,
             params: { subscriber: { user: subscriber.user,
                                     password: 'anything' } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when subscriber status isn\'t activated' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:pendent]
        subscriber.save!

        post :validate_subscriber_access,
             params: { subscriber: { user: subscriber.user,
                                     password: 'anything' } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when subscriber status isn\'t activated' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:pendent]
        subscriber.save!

        post :validate_subscriber_access,
             params: { subscriber: { user: subscriber.user,
                                     password: 'anything' } }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#send_subscriber_password' do
    it 'redirects to login page when send password only active subscriber' do
      allow(Notifications::ForgotMyPassword).to receive_message_chain(:send_password, :deliver_now) { true }

      subscriber = FactoryBot.create(:subscriber, email: 'anything@gmail.com')
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      post :send_subscriber_password, params: { password: { document: subscriber.document } }

      expect(response).to redirect_to(login_assinantes_path)
    end

    it 'shows success message when send password only active subscriber' do
      allow(Notifications::ForgotMyPassword).to receive_message_chain(:send_password, :deliver_now) { true }

      subscriber = FactoryBot.create(:subscriber, email: 'anything@gmail.com')
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      post :send_subscriber_password, params: { password: { document: subscriber.document } }

      expect(flash[:notice]).to eq("Senha enviada com sucesso para o email a******@gmail.com!")
    end

    it 'redirects to forgot password page when subscriber not found' do
      post :send_subscriber_password, params: { password: { document: 'any_document' } }

      expect(response).to redirect_to (login_assinantes_esqueci_minha_senha_path)
    end

    it 'shows error message when subscriber not found' do
      post :send_subscriber_password, params: { password: { document: 'any_document' } }

      expect(flash[:alert]).to eq('Falha no envio da senha!')
    end

    it 'redirects to forgot password page when occurs some errors' do
      allow(Subscriber).to receive(:find_by_document) { raise StandardError }

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      post :send_subscriber_password, params: { password: { document: subscriber.document } }

      expect(flash[:alert]).to eq('Falha no envio da senha!')
    end
  end

  describe '#validate_subscriber_access' do
    it 'redirects to dashboard page when access is allowed' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      post :validate_subscriber_access,
           params: { subscriber: { user: subscriber.user,
                                   password: subscriber.password } }

      expect(response).to redirect_to(dashboards_assinantes_path)
    end

    it 'redirects to login page when subscriber access isn\'t is allowed' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      post :validate_subscriber_access,
           params: { subscriber: { user: subscriber.user,
                                   password: 'anything' } }

      expect(response).to redirect_to(login_assinantes_path)
    end

    it 'shows error message when subscriber access isn\'t is allowed' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      post :validate_subscriber_access,
           params: { subscriber: { user: subscriber.user,
                                   password: 'anything' } }

      expect(flash[:alert]).to eq('Falha no acesso ao dashboard!')
    end

    it 'creates session containing subscriber data' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      post :validate_subscriber_access,
           params: { subscriber: { user: subscriber.user,
                                   password: subscriber.password } }

      expect(session[:subscriber_code]).to be_present
    end
  end
end
