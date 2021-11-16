# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::AdministratorPanel::Dashboard::Graphics', type: :request do
  before(:each) do
    allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }
  end

  describe '#escorts_by_status' do
    it 'returns data to escort chart by status' do
      chart_data = [{ status: 'aguardando confirmação', quantity: 13, piece_color: '#2200eb' },
                    { status: 'confirmada', quantity: 6, piece_color: '#28a745' },
                    { status: 'recusada', quantity: 21, piece_color: '#ffc107' }]

      allow(Order).to receive(:chart_by_status) { chart_data }

      get '/gestao/admin/dashboard/graficos/escorts_by_status'

      expected_result = { chart_data: chart_data }.to_json

      expect(response.body).to eq(expected_result)
    end

    it 'returns empty data when occurs errors' do
      allow(Order).to receive(:chart_by_status) { raise StandardError }

      get '/gestao/admin/dashboard/graficos/escorts_by_status'

      expected_result = { chart_data: [] }.to_json

      expect(response.body).to eq(expected_result)
    end
  end
end
