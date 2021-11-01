# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::OperatorPanel::Dashboard', type: :request do
  describe '#index' do
    context 'when is administrator profile' do
      it 'renders unauthorized page with http status code 401' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        get '/gestao/operador/dashboard/index'

        expect(response).to render_template(
          file: "#{Rails.root}/app/views/error_pages/401.html.erb"
        )
        expect(response).to have_http_status(401)
      end
    end

    context 'when is agent profile' do
      it 'renders unauthorized page with http status code 401' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'agent' }

        get '/gestao/operador/dashboard/index'

        expect(response).to render_template(
          file: "#{Rails.root}/app/views/error_pages/401.html.erb"
        )
        expect(response).to have_http_status(401)
      end
    end

    context 'when is lecturer profile' do
      it 'renders unauthorized page with http status code 401' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'lecturer' }

        get '/gestao/operador/dashboard/index'

        expect(response).to render_template(
          file: "#{Rails.root}/app/views/error_pages/401.html.erb"
        )
        expect(response).to have_http_status(401)
      end
    end

    context 'when is operator profile' do
      it 'renders operator dashboard page with http status code 200' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        get '/gestao/operador/dashboard/index'

        expect(response).to render_template(:index)
        expect(response).to have_http_status(200)
      end
    end

    context 'when occurs errors' do
      it 'renders internal server error page with http status code 500' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { raise StandardError }

        get '/gestao/operador/dashboard/index'

        expect(response).to render_template(
          file: "#{Rails.root}/app/views/error_pages/500.html.erb"
        )
        expect(response).to have_http_status(500)
      end
    end
  end

  describe '#order_management' do
    it 'renders operator dashboard page with http status code 200' do
      allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
      allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
      allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

      order = FactoryBot.create(:order, :scheduled)

      get "/gestao/operador/dashboard/gerenciamento/#{order.order_number}"

      expect(response).to render_template(:order_management)
    end
  end

  describe '#mount_items_list' do
    context 'when pass valid params' do
      it 'returns mission items in JSON format' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        mission_items = { calibers12: 'Nº ABC1234 | Nº XPTO9999',
                          calibers38: 'Nº ABC1111 | Nº XPTO0000',
                          munitions12: '24 projéteis',
                          munitions38: '50 projéteis',
                          waistcoats: 'Nº Série W1234 | Nº Série W5678',
                          radios: 'Nº Série R1234 | Nº Série R5678',
                          vehicles: 'Mercedes Preto - XYZ 9999' }

        allow(Builders::MissionItems).to receive_message_chain(:new, :mount!) { mission_items }

        post '/gestao/operador/dashboard/gerenciamento/mount_items_list.json',
             params: { 'items' => { 'calibers_12_quantity' => '1',
                                    'calibers_38_quantity' => '2',
                                    'munitions_12_quantity' => '24',
                                    'munitions_38_quantity' => '50',
                                    'waistcoats_quantity' => '2',
                                    'radios_quantity' => '2',
                                    'vehicles_quantity' => '1' } }

        expected_result = { descriptive_items: mission_items }.to_json

        expect(response.body).to eq(expected_result)
      end

      it 'returns HTTP status 200' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        mission_items = { calibers12: 'Nº ABC1234 | Nº XPTO9999',
                          calibers38: 'Nº ABC1111 | Nº XPTO0000',
                          munitions12: '24 projéteis',
                          munitions38: '50 projéteis',
                          waistcoats: 'Nº Série W1234 | Nº Série W5678',
                          radios: 'Nº Série R1234 | Nº Série R5678',
                          vehicles: 'Mercedes Preto - XYZ 9999' }

        allow(Builders::MissionItems).to receive_message_chain(:new, :mount!) { mission_items }

        post '/gestao/operador/dashboard/gerenciamento/mount_items_list.json',
             params: { 'items' => { 'calibers_12_quantity' => '1',
                                    'calibers_38_quantity' => '2',
                                    'munitions_12_quantity' => '24',
                                    'munitions_38_quantity' => '50',
                                    'waistcoats_quantity' => '2',
                                    'radios_quantity' => '2',
                                    'vehicles_quantity' => '1' } }

        expect(response).to have_http_status(200)
      end
    end

    context 'when occurs errors' do
      it 'returns empty hash in JSON format' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Builders::MissionItems).to receive_message_chain(:new, :mount!) { raise StandardError }

        post '/gestao/operador/dashboard/gerenciamento/mount_items_list.json',
             params: { 'items' => { 'calibers_12_quantity' => '1',
                                    'calibers_38_quantity' => '2',
                                    'munitions_12_quantity' => '24',
                                    'munitions_38_quantity' => '50',
                                    'waistcoats_quantity' => '2',
                                    'radios_quantity' => '2',
                                    'vehicles_quantity' => '1' } }

        expected_result = { descriptive_items: {} }.to_json

        expect(response.body).to eq(expected_result)
      end

      it 'returns HTTP status 500' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Builders::MissionItems).to receive_message_chain(:new, :mount!) { raise StandardError }

        post '/gestao/operador/dashboard/gerenciamento/mount_items_list.json',
             params: { 'items' => { 'calibers_12_quantity' => '1',
                                    'calibers_38_quantity' => '2',
                                    'munitions_12_quantity' => '24',
                                    'munitions_38_quantity' => '50',
                                    'waistcoats_quantity' => '2',
                                    'radios_quantity' => '2',
                                    'vehicles_quantity' => '1' } }

        expect(response).to have_http_status(500)
      end
    end
  end

  describe '#mount_team' do
    context 'when pass valid params' do
      it 'returns team in JSON format' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        team = { agents: 'Alves | Silva', team_name: 'Tango' }

        allow(Builders::Team).to receive_message_chain(:new, :mount!) { team }

        post '/gestao/operador/dashboard/gerenciamento/mount_team.json',
             params: { 'agent' => { 'quantity' => '2' } }

        expected_result = { team: team }.to_json

        expect(response.body).to eq(expected_result)
      end

      it 'returns HTTP status 200' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        team = { agents: 'Alves | Silva', team_name: 'Tango' }

        allow(Builders::Team).to receive_message_chain(:new, :mount!) { team }

        post '/gestao/operador/dashboard/gerenciamento/mount_team.json',
             params: { 'agent' => { 'quantity' => '2' } }

        expect(response).to have_http_status(200)
      end
    end

    context 'when occurs errors' do
      it 'returns empty hash in JSON format' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Builders::Team).to receive_message_chain(:new, :mount!) { raise StandardError }

        post '/gestao/operador/dashboard/gerenciamento/mount_team.json',
             params: { 'agent' => { 'quantity' => '2' } }

        expected_result = { team: {} }.to_json

        expect(response.body).to eq(expected_result)
      end

      it 'returns HTTP status 500' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Builders::Team).to receive_message_chain(:new, :mount!) { raise StandardError }

        post '/gestao/operador/dashboard/gerenciamento/mount_team.json',
             params: { 'agent' => { 'quantity' => '2' } }

        expect(response).to have_http_status(500)
      end
    end
  end

  describe '#refuse_team' do
    context 'when pass valid params' do
      context 'and is a first attempt' do
        it 'returns hash with attempts quantity in JSON format' do
          counter = 1
          attempt = 1
          allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
          allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
          allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

          post '/gestao/operador/dashboard/gerenciamento/refuse_team.json',
               params: { 'counter' => counter }

          expect(response.body).to eq("{\"exceeded_attempts\":false,\"attempts\":#{attempt}}")
          expect(response).to have_http_status(200)
        end
      end

      context 'and is a second attempt' do
        it 'returns hash with attempts quantity in JSON format' do
          counter = 1
          attempts = 2
          allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
          allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
          allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

          (0..(attempts - 1)).each do |_i|
            post '/gestao/operador/dashboard/gerenciamento/refuse_team.json',
                 params: { 'counter' => counter }
          end

          expect(response.body).to eq("{\"exceeded_attempts\":false,\"attempts\":#{attempts}}")
          expect(response).to have_http_status(200)
        end
      end

      context 'and is a third attempt' do
        it 'returns hash informing that the attempts were exceeded in JSON format' do
          counter = 1
          attempts = 3
          allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
          allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
          allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

          (0..(attempts - 1)).each do |_i|
            post '/gestao/operador/dashboard/gerenciamento/refuse_team.json',
                 params: { 'counter' => counter }
          end

          expect(response.body).to eq('{"exceeded_attempts":true,"attempts":null}')
          expect(response).to have_http_status(200)
        end
      end
    end

    context 'when occurs errors' do
      it 'returns hash with attempts quantity in JSON format' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        post '/gestao/operador/dashboard/gerenciamento/refuse_team.json',
             params: { 'counter' => 'invalid_param' }

        expect(response.body).to eq('{"exceeded_attempts":"error"}')
        expect(response).to have_http_status(500)
      end
    end
  end

  describe '#block_order' do
    context 'when pass valid params' do
      it 'updates order status to \'bloqueado\'' do
        FactoryBot.create(:status, name: 'bloqueado')
        order = FactoryBot.create(:order)
        employee_name = 'João'

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Order).to receive(:find_by_order_number) { order }
        allow(ServiceToken)
          .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }
        allow(Notifications::Order)
          .to receive_message_chain(:warn_about_blocking, :deliver_now!) { true }

        post '/gestao/operador/dashboard/gerenciamento/block_order.json',
             params: { block: true }

        result = Order.find_by_order_number(order.order_number).status.name

        expect(result).to eq('bloqueado')
      end

      it 'saves blocking reason' do
        FactoryBot.create(:status, name: 'bloqueado')
        order = FactoryBot.create(:order)
        employee_name = 'João'

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Order).to receive(:find_by_order_number) { order }
        allow(ServiceToken)
          .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }
        allow(Notifications::Order)
          .to receive_message_chain(:warn_about_blocking, :deliver_now!) { true }

        post '/gestao/operador/dashboard/gerenciamento/block_order.json',
             params: { block: true }

        result = Order.find_by_order_number(order.order_number).reason

        expect(result).to eq("Bloqueio por excesso de recusas do #{employee_name}")
      end

      it 'redirects to orders page' do
        FactoryBot.create(:status, name: 'bloqueado')
        order = FactoryBot.create(:order)
        employee_name = 'João'

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Order).to receive(:find_by_order_number) { order }
        allow(ServiceToken)
          .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }
        allow(Notifications::Order)
          .to receive_message_chain(:warn_about_blocking, :deliver_now!) { true }

        post '/gestao/operador/dashboard/gerenciamento/block_order.json',
             params: { block: true }

        expect(response).to redirect_to(employee_panel_operator_dashboard_index_path)
      end

      it 'shows blocking message' do
        FactoryBot.create(:status, name: 'bloqueado')
        order = FactoryBot.create(:order)
        employee_name = 'João'

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Order).to receive(:find_by_order_number) { order }
        allow(ServiceToken)
          .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }
        allow(Notifications::Order)
          .to receive_message_chain(:warn_about_blocking, :deliver_now!) { true }

        post '/gestao/operador/dashboard/gerenciamento/block_order.json',
             params: { block: true }

        expect(flash[:alert]).to eq("O pedido de escolta #{order.order_number} foi bloqueado " \
                                    'por excesso de recusas. Para desbloqueá-lo, solicite ao ' \
                                    'administrador')
      end
    end
  end

  describe '#refuse_order' do
    context 'when pass valid params' do
      it 'updates order status to \'cancelada\'' do
        FactoryBot.create(:status, name: 'cancelada')
        order = FactoryBot.create(:order)
        employee_name = 'João'
        reason = 'Carga inapropriada'

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Order).to receive(:find_by_order_number) { order }
        allow(ServiceToken)
          .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }

        post '/gestao/operador/dashboard/gerenciamento/refuse_order',
             params: { refuse_info: { order_number: order.order_number, reason: reason } }

        result = Order.find_by_order_number(order.order_number).status.name

        expect(result).to eq('cancelada')
      end

      it 'adds refuse reason' do
        FactoryBot.create(:status, name: 'cancelada')
        order = FactoryBot.create(:order)
        employee_name = 'João'
        reason = 'Carga inapropriada'

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Order).to receive(:find_by_order_number) { order }
        allow(ServiceToken)
          .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }

        post '/gestao/operador/dashboard/gerenciamento/refuse_order',
             params: { refuse_info: { order_number: order.order_number, reason: reason } }

        result = Order.find_by_order_number(order.order_number).reason

        expected_result = "Motivo: #{reason} | Cancelado por: #{employee_name}"

        expect(result).to eq(expected_result)
      end

      it 'shows success message' do
        FactoryBot.create(:status, name: 'cancelada')
        order = FactoryBot.create(:order)
        employee_name = 'João'
        reason = 'Carga inapropriada'

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Order).to receive(:find_by_order_number) { order }
        allow(ServiceToken)
          .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }

        post '/gestao/operador/dashboard/gerenciamento/refuse_order',
             params: { refuse_info: { order_number: order.order_number, reason: reason } }

        expect(flash[:notice]).to eq("Pedido #{order.order_number} recusado com sucesso!")
      end

      it 'redirects to orders page' do
        order = FactoryBot.create(:order)
        employee_name = 'João'
        reason = 'Carga inapropriada'

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Order).to receive(:find_by_order_number) { order }
        allow(ServiceToken)
          .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }

        post '/gestao/operador/dashboard/gerenciamento/refuse_order',
             params: { refuse_info: { order_number: order.order_number, reason: reason } }

        expect(response).to redirect_to(employee_panel_operator_dashboard_index_path)
      end
    end

    context 'when pass invalid params' do
      it 'no updates order status to \'cancelada\'' do
        order = FactoryBot.create(:order)
        employee_name = 'João'

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Order).to receive(:find_by_order_number) { order }
        allow(ServiceToken)
          .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }

        post '/gestao/operador/dashboard/gerenciamento/refuse_order',
             params: { refuse_info: { order_number: order.order_number, reason: nil } }

        result = Order.find_by_order_number(order.order_number).status.name

        expect(result).not_to eq('cancelada')
      end

      it 'shows error message' do
        order = FactoryBot.create(:order)
        employee_name = 'João'

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Order).to receive(:find_by_order_number) { order }
        allow(ServiceToken)
          .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }

        post '/gestao/operador/dashboard/gerenciamento/refuse_order',
             params: { refuse_info: { order_number: order.order_number, reason: nil } }

        expect(flash[:alert]).to eq('Falha na recusa do pedido!')
      end

      it 'redirects to orders page' do
        order = FactoryBot.create(:order)
        employee_name = 'João'

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        allow(Order).to receive(:find_by_order_number) { order }
        allow(ServiceToken)
          .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }

        post '/gestao/operador/dashboard/gerenciamento/refuse_order',
             params: { refuse_info: { order_number: order.order_number, reason: nil } }

        expect(response).to redirect_to(employee_panel_operator_dashboard_index_path)
      end
    end
  end

  describe '#confirm_order' do
    before(:each) do
      allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
      allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
      allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }
    end

    context 'when pass valid params' do
      it 'redirects to orders page' do
        mission_info = {"mission_info"=>
                         { "team"=>{ "team_name"=>"Charlie",
                                     "agents"=>"Coelho | Paz | Wanderson"},
                           "descriptive_items"=>{ "calibers12"=>"Nº E5189308 | Nº G06375711",
                                                  "calibers38"=>"Nº UH902995 | Nº WH146314",
                                                  "munitions12"=>"140 projéteis",
                                                  "munitions38"=>"50 projéteis",
                                                  "waistcoats"=>"Nº Série 160122345 | " \
                                                                "Nº Série 64151537",
                                                  "radios"=>"Nº Série 64",
                                                  "vehicles"=>"Moby Branco - FZL 9E48" },
                           "order_number"=>"20211029223838" }
        }

        allow(Builders::Mission).to receive_message_chain(:new, :mount!) { true }

        post '/gestao/operador/dashboard/gerenciamento/confirm_order', params: mission_info

        expect(response).to redirect_to(employee_panel_operator_dashboard_index_path)
      end

      it 'shows success message' do
        mission_info = {"mission_info"=>
                         { "team"=>{ "team_name"=>"Charlie",
                                     "agents"=>"Coelho | Paz | Wanderson"},
                           "descriptive_items"=>{ "calibers12"=>"Nº E5189308 | Nº G06375711",
                                                  "calibers38"=>"Nº UH902995 | Nº WH146314",
                                                  "munitions12"=>"140 projéteis",
                                                  "munitions38"=>"50 projéteis",
                                                  "waistcoats"=>"Nº Série 160122345 | " \
                                                                "Nº Série 64151537",
                                                  "radios"=>"Nº Série 64",
                                                  "vehicles"=>"Moby Branco - FZL 9E48" },
                           "order_number"=>"20211029223838" }
        }

        allow(Builders::Mission).to receive_message_chain(:new, :mount!) { true }

        post '/gestao/operador/dashboard/gerenciamento/confirm_order', params: mission_info

        expect(flash[:notice]).to eq('Missão criada com sucesso!')
      end
    end

    context 'when pass invalid params' do
      it 'redirects to orders page' do
        mission_info = {"mission_info"=>
                         { "team"=>{ "team_name"=>"Charlie",
                                     "agents"=>"Coelho | Paz | Wanderson"},
                           "descriptive_items"=>{ "calibers12"=>"Nº E5189308 | Nº G06375711",
                                                  "calibers38"=>"Nº UH902995 | Nº WH146314",
                                                  "munitions12"=>"140 projéteis",
                                                  "munitions38"=>"50 projéteis",
                                                  "waistcoats"=>"Nº Série 160122345 | " \
                                                                "Nº Série 64151537",
                                                  "radios"=>"Nº Série 64",
                                                  "vehicles"=>"Moby Branco - FZL 9E48" },
                           "order_number"=>"20211029223838" }
        }

        allow(Builders::Mission).to receive_message_chain(:new, :mount!) { raise StandardError }

        post '/gestao/operador/dashboard/gerenciamento/confirm_order', params: mission_info

        expect(response).to redirect_to(employee_panel_operator_dashboard_index_path)
      end

      it 'shows error message' do
        mission_info = {"mission_info"=>
                         { "team"=>{ "team_name"=>"Charlie",
                                     "agents"=>"Coelho | Paz | Wanderson"},
                           "descriptive_items"=>{ "calibers12"=>"Nº E5189308 | Nº G06375711",
                                                  "calibers38"=>"Nº UH902995 | Nº WH146314",
                                                  "munitions12"=>"140 projéteis",
                                                  "munitions38"=>"50 projéteis",
                                                  "waistcoats"=>"Nº Série 160122345 | " \
                                                                "Nº Série 64151537",
                                                  "radios"=>"Nº Série 64",
                                                  "vehicles"=>"Moby Branco - FZL 9E48" },
                           "order_number"=>"20211029223838" }
        }

        allow(Builders::Mission).to receive_message_chain(:new, :mount!) { raise StandardError }

        post '/gestao/operador/dashboard/gerenciamento/confirm_order', params: mission_info

        expect(flash[:alert]).to eq('Falha na criação da missão!')
      end
    end
  end
end
