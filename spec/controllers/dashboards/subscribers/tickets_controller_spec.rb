require 'rails_helper'

RSpec.describe Dashboards::Subscribers::TicketsController, type: :controller do
  describe 'GET actions' do
    describe '#new' do
      it 'returns http code 200 when does exist subscriber session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        get :new

        expect(response).to have_http_status(200)
      end

      it 'returns http code 302 when does\'t exist subscriber session' do
        get :new

        expect(response).to have_http_status(302)
      end
    end

    describe '#index' do
      it 'returns http code 200 when does exist subscriber session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        get :index

        expect(response).to have_http_status(200)
      end

      it 'returns http code 302 when does\'t exist subscriber session' do
        get :index

        expect(response).to have_http_status(302)
      end
    end

    describe '#show' do
      it 'returns http code 200 when does exist subscriber session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        ticket = FactoryBot.create(:ticket, subscriber: subscriber)

        get :show, params: { ticket_id: ticket.id, type: 'opened' }

        expect(response).to have_http_status(200)
      end 

      it 'returns http code 302 when does\'t exist subscriber session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!
        
        ticket = FactoryBot.create(:ticket, subscriber: subscriber)
        
        get :show, params: { ticket_id: ticket.id, type: 'opened' }

        expect(response).to have_http_status(302)
      end 
    end

    describe '#edit' do
      it 'returns http code 200 when does exist subscriber session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        ticket = FactoryBot.create(:ticket, subscriber: subscriber)

        get :edit, params: { ticket_id: ticket.id, type: 'available' }

        expect(response).to have_http_status(200)
      end

      it 'returns http code 302 when does\'t exist subscriber session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        ticket = FactoryBot.create(:ticket, subscriber: subscriber)

        get :edit, params: { ticket_id: ticket.id, type: 'available' }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST actions' do
    describe '#create' do
      it 'returns http code 302 when does exist subscriber session' do
        ticket_params = FactoryBot.attributes_for(:ticket)
        comment = 'Anything'
        ticket_params.merge!(comment: comment).merge!(author: 'João da Silva')

        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        post :create, params: { ticket: ticket_params }

        expect(response).to have_http_status(302)
      end

      it 'returns http code 302 when does\'t exist subscriber session' do
        ticket_params = FactoryBot.attributes_for(:ticket)
        comment = 'Anything'
        ticket_params.merge!(comment: comment).merge!(author: 'João da Silva')

        post :create, params: { ticket: ticket_params }

        expect(response).to have_http_status(302)
      end
    end

    describe '#reopen' do
      it 'returns http code 302 when does exist subscriber session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        ticket = FactoryBot.create(:ticket, subscriber: subscriber)
        ticket.update_attributes!(status: Status::TICKET_STATUSES[:finished])

        session[:subscriber_code] = subscriber.code

        post :reopen, params: { type: 'finished', ticket_id: ticket.id, ticket: { comment: 'Anything', author: 'José da Silva' } }

        expect(response).to have_http_status(302)
      end

      it 'returns http code 302 when does\'t exist subscriber session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        ticket = FactoryBot.create(:ticket, subscriber: subscriber)

        post :reopen, params: { type: 'finished', ticket_id: ticket.id, ticket: { comment: 'Anything', author: 'José da Silva' } }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#edit' do
    it 'assigns @ticket when pass valid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)

      get :edit, params: { ticket_id: ticket.id, type: 'available' }

      expect(assigns[:ticket]).to be_present
    end

    it 'no assigns @ticket when not have tickets' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      get :edit, params: { ticket_id: '1', type: 'available' }

      expect(assigns[:ticket]).to be_nil
    end

    it 'redirects to ticket dashboard when not have tickets' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      get :edit, params: { ticket_id: '1', type: 'available' }

      expect(response).to redirect_to(dashboards_assinantes_chamados_path)
    end

    it 'shows error message when not have tickets' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      get :edit, params: { ticket_id: '1', type: 'available' }

      expect(flash[:alert]).to eq('Ticket não encontrado!')
    end
  end

  describe '#reopen' do
    it 'changes ticket status to \'reincidente\' when pass valid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)
      ticket.update_attributes!(status: Status::TICKET_STATUSES[:finished])

      post :reopen, params: { type: 'finished', ticket_id: ticket.id, ticket: { comment: 'Anything', author: 'José da Silva' } }

      result = Ticket.find(ticket.id).status

      expect(result).to eq(Status::TICKET_STATUSES[:recurrence])
    end

    it 'adds new comment at ticket' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)
      ticket.update_attributes!(status: Status::TICKET_STATUSES[:finished])

      ticket_params = { comment: 'Anything', author: 'José da Silva' }

      post :reopen, params: { type: 'finished', ticket_id: ticket.id, ticket: ticket_params }

      expected_result = ticket_params.values.sort

      result = Ticket
                 .find(ticket.id)
                 .comments
                 .pluck(:content, :author)
                 .flatten
                 .sort

      expect(result).to eq(expected_result)
    end

    it 'no changes ticket status when pass invalid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)

      post :reopen, params: { type: 'finished', ticket_id: ticket.id, ticket: { comment: 'Anything', author: 'José da Silva' } }

      result = Ticket.find(ticket.id).status

      expect(result).to eq(ticket.status)
   end

    it 'redirects to ticket page when pass valid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)
      ticket.update_attributes!(status: Status::TICKET_STATUSES[:finished])

      post :reopen, params: { type: 'finished', ticket_id: ticket.id, ticket: { comment: 'Anything', author: 'José da Silva' } }

      expect(response).to redirect_to(show_ticket_path(ticket.id, type: Ticket::GROUPS[:recurrence]))
    end

    it 'shows success message when pass valid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)
      ticket.update_attributes!(status: Status::TICKET_STATUSES[:finished])

      post :reopen, params: { type: 'finished', ticket_id: ticket.id, ticket: { comment: 'Anything', author: 'José da Silva' } }

      result = Ticket.find(ticket.id).status

      expect(flash[:notice]).to eq('Chamado reaberto com sucesso! Aguarde a interaçáo da nossa equipe!')
    end

    it 'shows error message when pass invalid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)
      ticket.update_attributes!(status: Status::TICKET_STATUSES[:finished])

      post :reopen, params: { type: 'anything', ticket_id: ticket.id, ticket: { comment: 'Anything', author: 'José da Silva' } }

      expect(flash[:alert]).to eq('Ticket não encontrado!')
    end

    it 'redirects to tickets dashboard when pass invalid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)
      ticket.update_attributes!(status: Status::TICKET_STATUSES[:finished])

      post :reopen, params: { type: 'anything', ticket_id: ticket.id, ticket: { comment: 'Anything', author: 'José da Silva' } }

      expect(response).to redirect_to(dashboards_assinantes_chamados_path)
    end

    it 'shows error message then try reopen ticket of other subscriber' do
      subscriber_1 = FactoryBot.create(:subscriber)
      subscriber_1.status = Status::STATUSES[:activated]
      subscriber_1.save!

      session[:subscriber_code] = subscriber_1.code

      subscriber_2 = FactoryBot.build(:subscriber)
      ticket = FactoryBot.create(:ticket, subscriber: subscriber_2)
      ticket.update_attributes!(status: Status::TICKET_STATUSES[:finished])

      post :reopen, params: { type: 'finished', ticket_id: ticket.id, ticket: { comment: 'Anything', author: 'José da Silva' } }

      expect(flash[:alert]).to eq('Ticket não encontrado!')
    end

    it 'redirects to ticket dashboard then try reopen ticket other subscriber' do
      subscriber_1 = FactoryBot.create(:subscriber)
      subscriber_1.status = Status::STATUSES[:activated]
      subscriber_1.save!

      session[:subscriber_code] = subscriber_1.code

      subscriber_2 = FactoryBot.build(:subscriber)
      ticket = FactoryBot.create(:ticket, subscriber: subscriber_2)
      ticket.update_attributes!(status: Status::TICKET_STATUSES[:finished])

      post :reopen, params: { type: 'finished', ticket_id: ticket.id, ticket: { comment: 'Anything', author: 'José da Silva' } }

      expect(response).to redirect_to(dashboards_assinantes_chamados_path)
    end

    it 'shows error message when occurs some errors' do
      allow(Ticket).to receive(:find) { raise StardardError }

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)
      ticket.update_attributes!(status: Status::TICKET_STATUSES[:finished])

      post :reopen, params: { type: 'finished', ticket_id: ticket.id, ticket: { comment: 'Anything', author: 'José da Silva' } }

      expect(flash[:alert]).to eq('Ticket não encontrado!')
    end

    it 'redirects to tickets dashboard when occurs some errors' do
      allow(Ticket).to receive(:find) { raise StardardError }

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)
      ticket.update_attributes!(status: Status::TICKET_STATUSES[:finished])

      post :reopen, params: { type: 'finished', ticket_id: ticket.id, ticket: { comment: 'Anything', author: 'José da Silva' } }

      expect(response).to redirect_to(dashboards_assinantes_chamados_path)
    end
  end

  describe '#create' do
    it 'creates a new ticket when pass valid params' do
      subject = 'any subject'
      ticket_params = FactoryBot.attributes_for(:ticket, subject: subject)
      ticket_params.merge!(comment: 'Anything').merge!(author: 'João da Silva')

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      post :create, params: { ticket: ticket_params }

      result = Ticket.find_by_subject(subject)

      expect(result).to be_present
    end

    it 'creates a comment in new ticket when pass valid params' do
      author = 'João da Silva'
      subject = 'any subject'
      ticket_params = FactoryBot.attributes_for(:ticket, subject: subject)
      ticket_params.merge!(comment: 'Anything').merge!(author: author)

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      post :create, params: { ticket: ticket_params }

      expected_result = Comment.find_by_author(author)
      result = Ticket.find_by_subject(subject).comments

      expect(result).to include(expected_result)
    end

    it 'no creates a new ticket when pass invalid params' do
      author = 'João da Silva'
      ticket_params = FactoryBot.attributes_for(:ticket, subject: nil)
      ticket_params.merge!(comment: 'Anything').merge!(author: author)

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      post :create, params: { ticket: ticket_params }

      result = Ticket.find_by_subject(nil)

      expect(result).to be_nil
    end

    it 'no creates comment in a new ticket when pass invalid params' do
      author = 'João da Silva'
      ticket_params = FactoryBot.attributes_for(:ticket, subject: nil)
      ticket_params.merge!(comment: 'Anything').merge!(author: author)

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      post :create, params: { ticket: ticket_params }

      result = Comment.find_by_author(author)

      expect(result).to be_nil
    end

    it 'shows success message when create a new ticket' do
      ticket_params = FactoryBot.attributes_for(:ticket)
      ticket_params.merge!(comment: 'Anything').merge!(author: 'João da SIlva')

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      post :create, params: { ticket: ticket_params }

      expect(flash[:notice]).to eq('Dados gravados com sucesso!')
    end

    it 'shows error message when not create a new ticket' do
      ticket_params = FactoryBot.attributes_for(:ticket, subject: nil)
      ticket_params.merge!(comment: 'Anything').merge!(author: 'João da SIlva')
    
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      post :create, params: { ticket: ticket_params }

      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end

    it 'redirects to dashboard tickets when create a new ticket' do
      ticket_params = FactoryBot.attributes_for(:ticket)
      ticket_params.merge!(comment: 'Anything').merge!(author: 'João da SIlva')

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      post :create, params: { ticket: ticket_params }

      expect(response).to redirect_to(dashboards_assinantes_chamados_path)
    end

    it 'redirects to dashboard tickets when not create a new ticket' do
      ticket_params = FactoryBot.attributes_for(:ticket, subject: nil)
      ticket_params.merge!(comment: 'Anything').merge!(author: 'João da SIlva')

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      post :create, params: { ticket: ticket_params }

      expect(response).to redirect_to(dashboards_assinantes_chamados_path)
    end

    it 'shows error message when occurs some errors' do
      allow(Ticket).to receive(:new) { raise StandardError }

      ticket_params = FactoryBot.attributes_for(:ticket)
      ticket_params.merge!(comment: 'Anything').merge!(author: 'João da SIlva')

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      post :create, params: { ticket: ticket_params }

      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end

    it 'redirects to dashboard tickets when occurs some errors' do
      allow(Ticket).to receive(:new) { raise StandardError }

      ticket_params = FactoryBot.attributes_for(:ticket)
      ticket_params.merge!(comment: 'Anything').merge!(author: 'João da SIlva')

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      post :create, params: { ticket: ticket_params }

      expect(response).to redirect_to(dashboards_assinantes_chamados_path)
    end
  end

  describe '#new' do
    it 'creates a new Ticket instance' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      get :new

      expect(assigns[:new_ticket]).to be_present
    end
  end

  describe '#show' do
    it 'returns opened ticket when pass valid opened ticket id' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)

      get :show, params: { ticket_id: ticket.id, type: 'opened' }

      expect(assigns[:ticket]).to eq(ticket)
    end

    it 'returns ticket in treatment when pass valid ticket id in treatment' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)
      ticket.status = 'em andamento'
      ticket.save!

      get :show, params: { ticket_id: ticket.id, type: 'in_treatment' }
      
      expect(assigns[:ticket]).to eq(ticket)
    end

    it 'returns finished ticket when pass valid finished ticket id' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)
      ticket.status = 'finalizado'
      ticket.save!

      get :show, params: { ticket_id: ticket.id, type: 'finished' }
      
      expect(assigns[:ticket]).to eq(ticket)
    end

    it 'no returns opened ticket when pass invalid opened ticket id' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)
      ticket.status = 'finalizado'
      ticket.save!

      get :show, params: { ticket_id: ticket.id, type: 'opened' }
      
      expect(assigns[:ticket]).to be_nil
    end

    it 'no returns ticket when pass invalid ticket id in treatment' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)

      get :show, params: { ticket_id: ticket.id, type: 'in_treatment' }

      expect(assigns[:ticket]).to be_nil
    end

    it 'no returns ticket when pass invalid finished ticket id' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)

      get :show, params: { ticket_id: ticket.id, type: 'finished' }

      expect(assigns[:ticket]).to be_nil
    end

    it 'redirects to dashboard ticket when pass invalid opened ticket id' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)
      ticket.status = 'finalizado'
      ticket.save!

      get :show, params: { ticket_id: ticket.id, type: 'opened' }

      expect(response).to redirect_to(dashboards_assinantes_chamados_path)
    end

    it 'redirects to dashboard ticket when pass invalid ticket id in treatment' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)

      get :show, params: { ticket_id: ticket.id, type: 'in_treatment' }

      expect(response).to redirect_to(dashboards_assinantes_chamados_path)
    end

    it 'redirects to dashboard ticket when pass invalid finished ticket id' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)

      get :show, params: { ticket_id: ticket.id, type: 'finished' }

      expect(response).to redirect_to(dashboards_assinantes_chamados_path)
    end

    it 'shows error message when pass invalid opened ticket id' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)
      ticket.status = 'finalizado'
      ticket.save!

      get :show, params: { ticket_id: ticket.id, type: 'opened' }

      expect(flash[:alert]).to eq('Ticket não encontrado!')
    end

    it 'shows error message when pass invalid ticket id in treatment' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)

      get :show, params: { ticket_id: ticket.id, type: 'in_treatment' }

      expect(flash[:alert]).to eq('Ticket não encontrado!')
    end

    it 'shows error message when pass invalid finished ticket id' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)

      get :show, params: { ticket_id: ticket.id, type: 'finished' }

      expect(flash[:alert]).to eq('Ticket não encontrado!')
    end

    it 'shows error message when occurs some errors' do
      allow(Ticket).to receive(:find) { raise StandardError }

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)

      get :show, params: { ticket_id: ticket.id, type: 'opened' }

      expect(flash[:alert]).to eq('Falha ao mostrar tickets!')
    end

    it 'redirects to dashboard ticket when occurs some errors' do
      allow(Ticket).to receive(:find) { raise StandardError }

      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      ticket = FactoryBot.create(:ticket, subscriber: subscriber)

      get :show, params: { ticket_id: ticket.id, type: 'opened' }

      expect(response).to redirect_to(dashboards_assinantes_chamados_path)
    end
  end

  describe '#index' do
    context 'when ticket is opened' do
      it 'assigns opened ticket list when does exist opened tickets' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        opened_ticket = opened_ticket(subscriber)
        ticket_in_treatment = ticket_in_treatment(subscriber)
        ticket_waiting_subscriber = ticket_waiting_subscriber(subscriber)
        ticket_waiting_company = ticket_waiting_company(subscriber)
        finished_ticket = finished_ticket(subscriber)

        get :index

        expect(assigns[:opened]).to include(opened_ticket)
        expect(assigns[:opened]).not_to include(ticket_in_treatment)
        expect(assigns[:opened]).not_to include(ticket_waiting_subscriber)
        expect(assigns[:opened]).not_to include(ticket_waiting_company)
        expect(assigns[:opened]).not_to include(finished_ticket)
      end
    end

    context 'when ticket is finished' do
      it 'assigns finished ticket list when does exist finished ticket' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        opened_ticket = opened_ticket(subscriber)
        ticket_in_treatment = ticket_in_treatment(subscriber)
        ticket_waiting_subscriber = ticket_waiting_subscriber(subscriber)
        ticket_waiting_company = ticket_waiting_company(subscriber)
        finished_ticket = finished_ticket(subscriber)

        get :index

        expect(assigns[:finished]).to include(finished_ticket)
        expect(assigns[:finished]).not_to include(ticket_in_treatment)
        expect(assigns[:finished]).not_to include(ticket_waiting_subscriber)
        expect(assigns[:finished]).not_to include(ticket_waiting_company)
        expect(assigns[:finished]).not_to include(opened_ticket)
      end
    end
 
    context 'when ticket is in progress' do
      context 'assigns list of ticket in progress' do
        it 'when does exist tickets in treatment' do
          subscriber = FactoryBot.create(:subscriber)
          subscriber.status = Status::STATUSES[:activated]
          subscriber.save!

          session[:subscriber_code] = subscriber.code

          opened_ticket = opened_ticket(subscriber)
          ticket_in_treatment = ticket_in_treatment(subscriber)
          ticket_waiting_subscriber = ticket_waiting_subscriber(subscriber)
          ticket_waiting_company = ticket_waiting_company(subscriber)
          finished_ticket = finished_ticket(subscriber)
 
          get :index

          expect(assigns[:in_treatment]).to include(ticket_in_treatment)
          expect(assigns[:in_treatment]).to include(ticket_waiting_subscriber)
          expect(assigns[:in_treatment]).to include(ticket_waiting_company)
          expect(assigns[:in_treatment]).not_to include(opened_ticket)
          expect(assigns[:in_treatment]).not_to include(finished_ticket)
        end

        it 'when does exist tickets is waiting subscriber' do
          subscriber = FactoryBot.create(:subscriber)
          subscriber.status = Status::STATUSES[:activated]
          subscriber.save!

          session[:subscriber_code] = subscriber.code

          opened_ticket = opened_ticket(subscriber)
          ticket_in_treatment = ticket_in_treatment(subscriber)
          ticket_waiting_subscriber = ticket_waiting_subscriber(subscriber)
          ticket_waiting_company = ticket_waiting_company(subscriber)
          finished_ticket = finished_ticket(subscriber)

          get :index

          expect(assigns[:in_treatment]).to include(ticket_in_treatment)
          expect(assigns[:in_treatment]).to include(ticket_waiting_subscriber)
          expect(assigns[:in_treatment]).to include(ticket_waiting_company)
          expect(assigns[:in_treatment]).not_to include(opened_ticket)
          expect(assigns[:in_treatment]).not_to include(finished_ticket)
        end

        it 'when does exist tickets is waiting company' do
          subscriber = FactoryBot.create(:subscriber)
          subscriber.status = Status::STATUSES[:activated]
          subscriber.save!

          session[:subscriber_code] = subscriber.code

          opened_ticket = opened_ticket(subscriber)
          ticket_in_treatment = ticket_in_treatment(subscriber)
          ticket_waiting_subscriber = ticket_waiting_subscriber(subscriber)
          ticket_waiting_company = ticket_waiting_company(subscriber)
          finished_ticket = finished_ticket(subscriber)

          get :index

          expect(assigns[:in_treatment]).to include(ticket_in_treatment)
          expect(assigns[:in_treatment]).to include(ticket_waiting_subscriber)
          expect(assigns[:in_treatment]).to include(ticket_waiting_company)
          expect(assigns[:in_treatment]).not_to include(opened_ticket)
          expect(assigns[:in_treatment]).not_to include(finished_ticket)
        end
      end
    end
  end

  def opened_ticket(subscriber)
   ticket = FactoryBot.create(:ticket, subscriber: subscriber, status: Status::TICKET_STATUSES[:opened])
   ticket
  end

  def ticket_in_treatment(subscriber)
   ticket = FactoryBot.create(:ticket, subscriber: subscriber, status: Status::TICKET_STATUSES[:opened])
   ticket.status = Status::TICKET_STATUSES[:in_treatment]
   ticket.save!
   ticket
  end

  def ticket_waiting_subscriber(subscriber)
   ticket = FactoryBot.create(:ticket, subscriber: subscriber, status: Status::TICKET_STATUSES[:opened])
   ticket.status = Status::TICKET_STATUSES[:waiting_subscriber]
   ticket.save!
   ticket
  end

  def ticket_waiting_company(subscriber)
   ticket = FactoryBot.create(:ticket, subscriber: subscriber, status: Status::TICKET_STATUSES[:opened])
   ticket.status = Status::TICKET_STATUSES[:waiting_company]
   ticket.save!
   ticket
  end
      
  def finished_ticket(subscriber)
    ticket = FactoryBot.create(:ticket, subscriber: subscriber, status: Status::TICKET_STATUSES[:opened])
    ticket.status = Status::TICKET_STATUSES[:finished]
    ticket.save!
    ticket
  end
end
