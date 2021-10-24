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
end
