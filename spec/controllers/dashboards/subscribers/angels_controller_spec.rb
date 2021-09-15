require 'rails_helper'

RSpec.describe Dashboards::Subscribers::AngelsController, type: :controller do
  describe 'GET actions' do
    describe '#index' do
      it 'returns http status code 200' do
        create_subscriber_session

        get :index

        expect(response).to have_http_status(200)
      end 

      it 'returns http status code 302 when doesn\'t exist subscriber session' do
        session[:subscriber_code] = nil 

        get :index

        expect(response).to have_http_status(302)
      end 
    end

    describe '#insert' do
      it 'returns http status code 200' do
        create_subscriber_session

        get :insert

        expect(response).to have_http_status(200)
      end 

      it 'returns http status code 302 when doesn\'t exist subscriber session' do
        session[:subscriber_code] = nil 

        get :insert

        expect(response).to have_http_status(302)
      end
    end

    describe '#edit' do
      it 'returns http status code 200' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        angel = FactoryBot.create(:angel, subscriber: subscriber)

        get :edit, params: { angel: angel.id }

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when doesn\'t exist subscriber session' do
        session[:subscriber_code] = nil

        subscriber = FactoryBot.create(:subscriber)
        angel = FactoryBot.create(:angel, subscriber: subscriber)

        get :edit, params: { angel: angel.id }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST actions' do
    describe '#create' do
      it 'returns http status code 200' do
        create_subscriber_session

        angel_params = FactoryBot.attributes_for(:angel)

        post :create, params: { angel: angel_params }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when doesn\'t exist subscriber session' do
        session[:subscriber_code] = nil

        angel_params = FactoryBot.attributes_for(:angel)

        post :create, params: angel_params

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'PUT actions' do
    describe '#update' do
      it 'returns http status code 302' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        angel = FactoryBot.create(:angel, subscriber: subscriber)

        put :update, params: { angel: {name: angel.name, cpf: angel.cpf, status: angel.status },
                               angel_id: angel.id }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'DELETE actions' do
    describe '#remove' do
      it 'returns http status code 302' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        angel = FactoryBot.create(:angel, subscriber: subscriber)

        delete :remove, params: { angel: angel.id }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#insert' do
    it 'assigns variable with a new angel instance' do
      create_subscriber_session

      get :insert

      expect(assigns[:angel]).to be_present
    end
  end

  describe '#edit' do
    it 'assigns variable with angel data' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, subscriber: subscriber)

      get :edit, params: { angel: angel.id }

      expect(assigns[:angel]).to be_present
    end

    it 'redirects to angels page when occurs some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, subscriber: subscriber)

      get :edit, params: { angel: nil }

      expect(response).to redirect_to(dashboards_assinantes_angels_path)
    end

    it 'shows error message when occurs some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, subscriber: subscriber)

      get :edit, params: { angel: nil }

      expect(flash[:alert]).to eq('Erro ao localizar dados!')
    end

    it 'redirects to angels page when angel not belong at subscriber' do
      subscriber_1 = FactoryBot.create(:subscriber)
      subscriber_1.status = Status::STATUSES[:activated]
      subscriber_1.save!

      session[:subscriber_code] = subscriber_1.code

      angel_1 = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber_1)

      subscriber_2 = FactoryBot.build(:subscriber)
      subscriber_2.valid?
      subscriber_2.save!
      subscriber_2.status = Status::STATUSES[:activated]
      subscriber_2.save!

      angel_2 = FactoryBot.create(:angel, subscriber: subscriber_2)

      get :edit, params: { angel: angel_2.id }

      expect(response).to redirect_to(dashboards_assinantes_angels_path)
    end

    it 'shows error message when angel not belong at subscriber' do
      subscriber_1 = FactoryBot.create(:subscriber)
      subscriber_1.status = Status::STATUSES[:activated]
      subscriber_1.save!

      session[:subscriber_code] = subscriber_1.code

      angel_1 = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber_1)

      subscriber_2 = FactoryBot.build(:subscriber)
      subscriber_2.valid?
      subscriber_2.save!
      subscriber_2.status = Status::STATUSES[:activated]
      subscriber_2.save!

      angel_2 = FactoryBot.create(:angel, subscriber: subscriber_2)

      get :edit, params: { angel: angel_2.id }

      expect(flash[:alert]).to eq('Erro ao localizar dados!')
    end
  end

  describe '#create' do
    it 'creates a new angel when pass valid params' do
      create_subscriber_session

      cpf = '123.456.789-00'
      angel_params = FactoryBot.attributes_for(:angel, cpf: cpf)

      post :create, params: { angel: angel_params }

      expect(Angel.find_by_cpf(cpf)).to be_present
    end

    it 'redirects to angel page when pass valid params' do
      create_subscriber_session

      cpf = '123.456.789-00'
      angel_params = FactoryBot.attributes_for(:angel, cpf: cpf)

      post :create, params: { angel: angel_params }

      expect(response).to redirect_to(dashboards_assinantes_angels_path)
    end

    it 'shows success message when pass valid params' do
      create_subscriber_session

      cpf = '123.456.789-00'
      angel_params = FactoryBot.attributes_for(:angel, cpf: cpf)

      post :create, params: { angel: angel_params }

      expect(flash[:notice]).to eq('Dados gravados com sucesso!')
    end

    it 'does not create a new angel when pass invalid params' do
      create_subscriber_session

      cpf = '12345'
      angel_params = FactoryBot.attributes_for(:angel, cpf: cpf)

      post :create, params: { angel: angel_params }

      expect(Angel.find_by_cpf(cpf)).to be_nil
    end

    it 'redirects to angel page when pass invalid params' do
      create_subscriber_session

      cpf = '12345'
      angel_params = FactoryBot.attributes_for(:angel, cpf: cpf)

      post :create, params: { angel: angel_params }

      expect(response).to redirect_to(dashboards_assinantes_angels_path)
    end

    it 'shows error message when pass invalid params' do
      create_subscriber_session

      cpf = '12345'
      angel_params = FactoryBot.attributes_for(:angel, cpf: cpf)

      post :create, params: { angel: angel_params }

      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end

    it 'does not create a new angel when occurs some errors' do
      allow(Angel).to receive(:new) { raise StandardError }

      create_subscriber_session

      cpf = '123.456.789-00'
      angel_params = FactoryBot.attributes_for(:angel, cpf: cpf)

      post :create, params: { angel: angel_params }

      expect(Angel.find_by_cpf(cpf)).to be_nil
    end

    it 'redirects to angel page when occurs some errors' do
      allow(Angel).to receive(:new) { raise StandardError }

      create_subscriber_session

      cpf = '123.456.789-00'
      angel_params = FactoryBot.attributes_for(:angel, cpf: cpf)

      post :create, params: { angel: angel_params }

      expect(response).to redirect_to(dashboards_assinantes_angels_path)
    end

    it 'shows error message when occurs some errors' do
      allow(Angel).to receive(:new) { raise StandardError }

      create_subscriber_session

      cpf = '123.456.789-00'
      angel_params = FactoryBot.attributes_for(:angel, cpf: cpf)

      post :create, params: { angel: angel_params }

      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end
  end

  describe '#update' do
    it 'updates angel data when pass valid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)
      new_cpf = '999.999.999-99'

      put :update, params: { angel: {name: angel.name, cpf: new_cpf, status: angel.status },
                             angel_id: angel.id }

      expect(Angel.find(angel.id).cpf).to eq(new_cpf)
    end

    it 'redirects to angels page when pass valid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)

      put :update, params: { angel: {name: angel.name, cpf: angel.cpf, status: angel.status },
                             angel_id: angel.id }

      expect(response).to redirect_to(dashboards_assinantes_angels_path)
    end

    it 'shows success message when pass valid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)

      put :update, params: { angel: {name: angel.name, cpf: angel.cpf, status: angel.status },
                             angel_id: angel.id }

      expect(flash[:notice]).to eq('Dados atualizados com sucesso!')
    end

    it 'does not update angel data when angel not belong at subscriber' do
      subscriber_1 = FactoryBot.create(:subscriber)
      subscriber_1.status = Status::STATUSES[:activated]
      subscriber_1.save!

      session[:subscriber_code] = subscriber_1.code

      angel_1 = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber_1)

      subscriber_2 = FactoryBot.build(:subscriber)
      subscriber_2.valid?
      subscriber_2.save!
      subscriber_2.status = Status::STATUSES[:activated]
      subscriber_2.save!

      angel_2 = FactoryBot.create(:angel, subscriber: subscriber_2)

      new_cpf = '999.999.999-99'

      put :update, params: { angel: {name: angel_1.name, cpf: new_cpf, status: angel_1.status },
                             angel_id: angel_2.id }

      expect(Angel.find(angel_1.id).cpf).to eq(angel_1.cpf)
    end

    it 'shows error message when angel data when angel not belong at subscriber' do
      subscriber_1 = FactoryBot.create(:subscriber)
      subscriber_1.status = Status::STATUSES[:activated]
      subscriber_1.save!

      session[:subscriber_code] = subscriber_1.code

      angel_1 = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber_1)

      subscriber_2 = FactoryBot.build(:subscriber)
      subscriber_2.valid?
      subscriber_2.save!
      subscriber_2.status = Status::STATUSES[:activated]
      subscriber_2.save!

      angel_2 = FactoryBot.create(:angel, subscriber: subscriber_2)

      new_cpf = '999.999.999-99'

      put :update, params: { angel: {name: angel_1.name, cpf: new_cpf, status: angel_1.status },
                             angel_id: angel_2.id }

      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end

    it 'redirects to angels page when angel not belong at subscriber' do
      subscriber_1 = FactoryBot.create(:subscriber)
      subscriber_1.status = Status::STATUSES[:activated]
      subscriber_1.save!

      session[:subscriber_code] = subscriber_1.code

      angel_1 = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber_1)

      subscriber_2 = FactoryBot.build(:subscriber)
      subscriber_2.valid?
      subscriber_2.save!
      subscriber_2.status = Status::STATUSES[:activated]
      subscriber_2.save!

      angel_2 = FactoryBot.create(:angel, subscriber: subscriber_2)

      new_cpf = '999.999.999-99'

      put :update, params: { angel: {name: angel_1.name, cpf: new_cpf, status: angel_1.status },
                             angel_id: angel_2.id }

      expect(response).to redirect_to(dashboards_assinantes_angels_path)
    end

    it 'does not update angel data when pass invalid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)
      new_cpf = nil

      put :update, params: { angel: {name: angel.name, cpf: new_cpf, status: angel.status },
                             angel_id: angel.id }

      expect(Angel.find(angel.id).cpf).not_to eq(new_cpf)
    end

    it 'redirects to angels page when pass invalid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)
      new_cpf = nil

      put :update, params: { angel: {name: angel.name, cpf: new_cpf, status: angel.status },
                             angel_id: angel.id }

      expect(response).to redirect_to(dashboards_assinantes_angels_path)
    end

    it 'shows error message when pass invalid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)
      new_cpf = nil

      put :update, params: { angel: {name: angel.name, cpf: new_cpf, status: angel.status },
                             angel_id: angel.id }

      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end

    it 'does not update angel data when occurs some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)
      new_cpf = '999.999.999-99'

      put :update, params: { angel: {name: angel.name, cpf: new_cpf, status: angel.status },
                             angel_id: nil }

      expect(Angel.find(angel.id).cpf).to eq(angel.cpf)
    end

    it 'redirects to angels page when occurs some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)

      put :update, params: { angel: {name: angel.name, cpf: angel.cpf, status: angel.status },
                             angel_id: nil }

      expect(response).to redirect_to(dashboards_assinantes_angels_path)
    end

    it 'redirects to angels page when occurs some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)

      put :update, params: { angel: {name: angel.name, cpf: angel.cpf, status: angel.status },
                             angel_id: nil }

      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end
  end

  describe '#remove' do
    it 'removes angel data when pass valid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)

      delete :remove, params: { angel: angel.id }

      expect(Angel.find_by_cpf(angel.cpf)).to be_nil
    end

    it 'redirects to angels page when pass valid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)

      delete :remove, params: { angel: angel.id }

      expect(response).to redirect_to(dashboards_assinantes_angels_path)
    end

    it 'shows success message when pass valid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)

      delete :remove, params: { angel: angel.id }

      expect(flash[:notice]).to eq('Dados removidos com sucesso!')
    end

    it 'does not remove angel data when angel not belong at subscriber' do
      subscriber_1 = FactoryBot.create(:subscriber)
      subscriber_1.status = Status::STATUSES[:activated]
      subscriber_1.save!

      session[:subscriber_code] = subscriber_1.code

      angel_1 = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber_1)

      subscriber_2 = FactoryBot.build(:subscriber)
      subscriber_2.valid?
      subscriber_2.save!
      subscriber_2.status = Status::STATUSES[:activated]
      subscriber_2.save!

      angel_2 = FactoryBot.create(:angel, subscriber: subscriber_2)

      delete :remove, params: { angel: angel_2.id }

      expect(Angel.find(angel_2.id)).to be_present
    end

    it 'shows error message when angel data when angel not belong at subscriber' do
      subscriber_1 = FactoryBot.create(:subscriber)
      subscriber_1.status = Status::STATUSES[:activated]
      subscriber_1.save!

      session[:subscriber_code] = subscriber_1.code

      angel_1 = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber_1)

      subscriber_2 = FactoryBot.build(:subscriber)
      subscriber_2.valid?
      subscriber_2.save!
      subscriber_2.status = Status::STATUSES[:activated]
      subscriber_2.save!

      angel_2 = FactoryBot.create(:angel, subscriber: subscriber_2)

      delete :remove, params: { angel: angel_2.id }

      expect(flash[:alert]).to eq('Erro ao remover dados!')
    end

    it 'redirects to angels page when angel not belong at subscriber' do
      subscriber_1 = FactoryBot.create(:subscriber)
      subscriber_1.status = Status::STATUSES[:activated]
      subscriber_1.save!

      session[:subscriber_code] = subscriber_1.code

      angel_1 = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber_1)

      subscriber_2 = FactoryBot.build(:subscriber)
      subscriber_2.valid?
      subscriber_2.save!
      subscriber_2.status = Status::STATUSES[:activated]
      subscriber_2.save!

      angel_2 = FactoryBot.create(:angel, subscriber: subscriber_2)

      delete :remove, params: { angel: angel_2.id }

      expect(response).to redirect_to(dashboards_assinantes_angels_path)
    end

    it 'does not remove angel data when occurs some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)

      delete :remove, params: { angel: nil }

      expect(Angel.find(angel.id)).to be_present
    end

    it 'redirects to angels page when occurs some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)

      delete :remove, params: { angel: nil }

      expect(response).to redirect_to(dashboards_assinantes_angels_path)
    end

    it 'redirects to angels page when occurs some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      angel = FactoryBot.create(:angel, cpf: '123.456.789-00', subscriber: subscriber)

      delete :remove, params: { angel: nil }

      expect(flash[:alert]).to eq('Erro ao remover dados!')
    end
  end

  def create_subscriber_session
    subscriber = FactoryBot.create(:subscriber)
    subscriber.status = Status::STATUSES[:activated]
    subscriber.save!

    session[:subscriber_code] = subscriber.code
  end
end
