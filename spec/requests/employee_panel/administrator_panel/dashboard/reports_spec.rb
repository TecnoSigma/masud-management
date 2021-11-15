# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::AdministratorPanel::Dashboard::Reports', type: :request do
  before(:each) do
    allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }
  end

  describe '#escorts' do
    it 'renders escorts general report in PDF format' do
      get '/gestao/admin/dashboard/relatorios/escoltas.pdf'

      expect(response).to render_template(:escorts)
    end
  end

  describe '#customers' do
    it 'renders customers general report in PDF format' do
      get '/gestao/admin/dashboard/relatorios/clientes.pdf'

      expect(response).to render_template(:customers)
    end
  end

  describe '#escorts' do
    it 'renders guns general eport in PDF format' do
      get '/gestao/admin/dashboard/relatorios/armas.pdf'

      expect(response).to render_template(:guns)
    end
  end

  describe '#munitions' do
    it 'renders munitions general report in PDF format' do
      get '/gestao/admin/dashboard/relatorios/municoes.pdf'

      expect(response).to render_template(:munitions)
    end
  end

  describe '#tackles' do
    it 'renders tackles general report in PDF format' do
      get '/gestao/admin/dashboard/relatorios/equipamentos.pdf'

      expect(response).to render_template(:tackles)
    end
  end

  describe '#employees' do
    it 'renders employees general eport in PDF format' do
      get '/gestao/admin/dashboard/relatorios/funcionarios.pdf'

      expect(response).to render_template(:employees)
    end
  end

  describe '#vehicles' do
    it 'renders vehicles general eport in PDF format' do
      get '/gestao/admin/dashboard/relatorios/viaturas.pdf'

      expect(response).to render_template(:vehicles)
    end
  end
end
