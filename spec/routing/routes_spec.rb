require 'rails_helper'

RSpec.describe 'Routes', type: :routing do
  context 'HomeController' do
    context 'GET actions' do
      it { expect(get('/')).to route_to('home#index') }
      it { expect(get('home/chart_data')).to route_to('home#chart_data') }
      it { expect(get('home/hire')).to route_to('home#hire') }
      it { expect(get('home/contrato')).to route_to('home#contract') }
      it { expect(get('home/representantes')).to route_to('home#seller') }
      it { expect(get('home/representantes/contratar')).to route_to('home#hire_seller') }
      it { expect(get('home/representantes/contrato')).to route_to('home#seller_contract') }
    end

    context 'POST actions' do
      it { expect(post('home/representantes/create')).to route_to('home#create_seller') }
    end 
  end

  context 'SellerLoginsController' do
    context 'GET actions' do
      it { expect(get('login/representantes')).to route_to('seller_logins#index') }
      it { expect(get('login/representantes/esqueci_minha_senha')).to route_to('seller_logins#forgot_my_password') }
    end

    context 'POST actions' do
      it { expect(post('login/representantes/validate_access')).to route_to('seller_logins#validate_seller_access') }
      it { expect(post('login/representantes/send_password')).to route_to('seller_logins#send_seller_password') }
    end
  end

  context 'SubscriberLoginsController' do
    context 'GET actions' do
      it { expect(get('login/assinantes')).to route_to('subscriber_logins#index') }
      it { expect(get('login/assinantes/esqueci_minha_senha')).to route_to('subscriber_logins#forgot_my_password') }
    end

    context 'POST actions' do
      it { expect(post('login/assinantes/validate_access')).to route_to('subscriber_logins#validate_subscriber_access') }
      it { expect(post('login/assinantes/send_password')).to route_to('subscriber_logins#send_subscriber_password') }
    end
  end

  context 'CheckoutController' do
    context 'GET actions' do
      it { expect(get('checkout/identificacao')).to route_to('checkout#identification') }
      it { expect(get('checkout/identificacao/novo_assinante')).to route_to('checkout#new_subscriber') }
      it { expect(get('checkout/identificacao/assinante')).to route_to('checkout#subscriber') }
      it { expect(get('checkout/veiculos')).to route_to('checkout#vehicles') }
      it { expect(get('checkout/resumo')).to route_to('checkout#resume') }
      it { expect(get('checkout/subscriber_address')).to route_to('checkout#subscriber_address') }
      it { expect(get('checkout/user_availability')).to route_to('checkout#user_availability') }
      it { expect(get('checkout/vehicle_model_list')).to route_to('checkout#vehicle_model_list') }
      it { expect(get('checkout/subscriber_ip')).to route_to('checkout#subscriber_ip') }
      it { expect(get('checkout/pagamento')).to route_to('checkout#payment') }
      it { expect(get('checkout/finalizacao')).to route_to('checkout#finalization') }
      it { expect(get('checkout/add_vehicles')).to route_to('checkout#add_vehicles') }
      it { expect(get('checkout/remove_vehicles')).to route_to('checkout#remove_vehicles') }
      it { expect(get('checkout/check_seller')).to route_to('checkout#check_seller') }
    end

    context 'POST actions' do
      it { expect(post('checkout/subscriber_info')).to route_to('checkout#subscriber_info') }
      it { expect(post('checkout/process_payment')).to route_to('checkout#process_payment') }
      it { expect(post('checkout/find_subscriber_data')).to route_to('checkout#find_subscriber_data') }
    end
  end

  context 'DashboardsSubscribersController' do
    context 'GET actions' do
      it { expect(get('dashboards/assinantes/')).to route_to('dashboards/subscribers/main#index') }
      it { expect(get('dashboards/assinantes/logout')).to route_to('dashboards/subscribers/main#logout') }
      it { expect(get('dashboards/assinantes/monitoramento')).to route_to('dashboards/subscribers/monitoring#index') }
      it { expect(get('dashboards/assinantes/chamados/')).to route_to('dashboards/subscribers/tickets#index') }
      it { expect(get('dashboards/assinantes/chamados/novo')).to route_to('dashboards/subscribers/tickets#new') }
      it { expect(get('dashboards/assinantes/chamados/1')).to route_to('dashboards/subscribers/tickets#show', ticket_id: '1') }
      it { expect(get('dashboards/assinantes/chamados/1/editar')).to route_to('dashboards/subscribers/tickets#edit', ticket_id: '1') }
    end

    context 'POST actions' do
      it { expect(post('dashboards/assinantes/chamados/create')).to route_to('dashboards/subscribers/tickets#create') }
      it { expect(post('dashboards/assinantes/chamados/reopen/1')).to route_to('dashboards/subscribers/tickets#reopen', ticket_id: '1') }
    end
  end

  context 'DashboardsSubscribersMainController' do
    context 'GET actions' do
      it { expect(get('dashboards/assinantes')).to route_to('dashboards/subscribers/main#index') }
      it { expect(get('dashboards/assinantes/logout')).to route_to('dashboards/subscribers/main#logout') }
    end
  end

  context 'DashboardsSubscribersVehiclesController' do
    context 'GET actions' do
      it { expect(get('dashboards/assinantes/veiculos')).to route_to('dashboards/subscribers/vehicles#index') }
      it { expect(get('dashboards/assinantes/veiculos/1/adicionar_fotos')).to route_to('dashboards/subscribers/vehicles#add_photos', vehicle_id: '1') }
      it { expect(get('dashboards/assinantes/veiculos/1/detalhes')).to route_to('dashboards/subscribers/vehicles#details', vehicle_id: '1') }
    end

    context 'POST actions' do
      it { expect(post('dashboards/assinantes/veiculos/upload_photos')).to route_to('dashboards/subscribers/vehicles#upload_photos') }
    end
  end

  context 'DashboardsSubscribersDriversController' do
    context 'GET actions' do
      it { expect(get('dashboards/assinantes/motoristas')).to route_to('dashboards/subscribers/drivers#index') }
      it { expect(get('dashboards/assinantes/motoristas/adicionar')).to route_to('dashboards/subscribers/drivers#insert') }
      it { expect(get('dashboards/assinantes/motoristas/1/editar')).to route_to('dashboards/subscribers/drivers#edit', driver_id: '1') }
      it { expect(get('dashboards/assinantes/motoristas/1/detalhes')).to route_to('dashboards/subscribers/drivers#details', driver_id: '1') }
    end

    context 'POST actions' do
      it { expect(post('dashboards/assinantes/motoristas/create')).to route_to('dashboards/subscribers/drivers#create') }
    end

    context 'PUT actions' do
      it { expect(post('dashboards/assinantes/motoristas/update')).to route_to('dashboards/subscribers/drivers#update') }
    end

    context 'DELETE actions' do
      it { expect(delete('dashboards/assinantes/motoristas/1/remove')).to route_to('dashboards/subscribers/drivers#remove', driver_id: '1') }
    end
  end

  context 'DashboardsSubscribersInformationsMainController' do
    context 'GET actions' do
      it { expect(get('dashboards/assinantes/informacoes_pessoais')).to route_to('dashboards/subscribers/informations/main#index') }
    end
  end

  context 'DashboardsSubscribersInformationsRegisterController' do
    context 'GET actions' do
      it { expect(get('dashboards/assinantes/informacoes_pessoais/cadastro')).to route_to('dashboards/subscribers/informations/register#index') }
      it { expect(get('dashboards/assinantes/informacoes_pessoais/cadastro/editar')).to route_to('dashboards/subscribers/informations/register#edit') }
    end

    context 'PUT actions' do
      it { expect(put('dashboards/assinantes/informacoes_pessoais/cadastro/update')).to route_to('dashboards/subscribers/informations/register#update') }
    end
  end

  context 'DashboardsSubscribersInformationsDocumentsController' do
    context 'GET actions' do
      it { expect(get('dashboards/assinantes/informacoes_pessoais/documentos')).to route_to('dashboards/subscribers/informations/documents#index') }
      it { expect(get('dashboards/assinantes/informacoes_pessoais/documentos/contrato')).to route_to('dashboards/subscribers/informations/documents#contract') }
      it { expect(get('dashboards/assinantes/informacoes_pessoais/documentos/distrato')).to route_to('dashboards/subscribers/informations/documents#distract') }
    end
  end

  context 'DashboardsSubscribersAngelsController' do
    context 'GET actions' do
      it { expect(get('dashboards/assinantes/angels')).to route_to('dashboards/subscribers/angels#index') }
      it { expect(get('dashboards/assinantes/angels/adicionar')).to route_to('dashboards/subscribers/angels#insert') }
      it { expect(get('dashboards/assinantes/angels/editar')).to route_to('dashboards/subscribers/angels#edit') }
    end

    context 'POST actions' do
      it { expect(post('dashboards/assinantes/angels/create')).to route_to('dashboards/subscribers/angels#create') }
    end

    context 'DELETE actions' do
      it { expect(delete('dashboards/assinantes/angels/remove')).to route_to('dashboards/subscribers/angels#remove') }
    end

    context 'PUT actions' do
      it { expect(put('dashboards/assinantes/angels/update')).to route_to('dashboards/subscribers/angels#update') }
    end
  end

  context 'DashboardsSellersMainController' do
    context 'GET actions' do
      it { expect(get('dashboards/representantes')).to route_to('dashboards/sellers/main#index') }
      it { expect(get('dashboards/representantes/logout')).to route_to('dashboards/sellers/main#logout') }
    end
  end

  context 'DashboardsSellersInformationsMainController' do
    context 'GET actions' do
      it { expect(get('dashboards/representantes/informacoes_pessoais')).to route_to('dashboards/sellers/informations/main#index') }
    end
  end

  context 'DashboardsSellersInformationsDocumentsController' do
    context 'GET actions' do
      it { expect(get('dashboards/representantes/informacoes_pessoais/documentos')).to route_to('dashboards/sellers/informations/documents#index') }
      it { expect(get('dashboards/representantes/informacoes_pessoais/documentos/contrato')).to route_to('dashboards/sellers/informations/documents#contract') }
      it { expect(get('dashboards/representantes/informacoes_pessoais/documentos/distrato')).to route_to('dashboards/sellers/informations/documents#distract') }
    end
  end

  context 'DashboardsSellersInformationsRegisterController' do
    context 'GET actions' do
      it { expect(get('dashboards/representantes/informacoes_pessoais/cadastro')).to route_to('dashboards/sellers/informations/register#index') }
      it { expect(get('dashboards/representantes/informacoes_pessoais/cadastro/editar')).to route_to('dashboards/sellers/informations/register#edit') }
    end

    context 'PUT actions' do                                                                                                                                                              
      it { expect(put('dashboards/representantes/informacoes_pessoais/cadastro/update')).to route_to('dashboards/sellers/informations/register#update') }
    end
  end

  context 'DashboardsSellersInformationsBankingController' do
    context 'GET actions' do
      it { expect(get('dashboards/representantes/informacoes_pessoais/dados_bancarios')).to route_to('dashboards/sellers/informations/banking#index') }
      it { expect(get('dashboards/representantes/informacoes_pessoais/dados_bancarios/editar')).to route_to('dashboards/sellers/informations/banking#edit') }
      it { expect(get('dashboards/representantes/informacoes_pessoais/dados_bancarios/adicionar')).to route_to('dashboards/sellers/informations/banking#insert') }
    end

    context 'POST actions' do
      it { expect(post('dashboards/representantes/informacoes_pessoais/dados_bancarios/create')).to route_to('dashboards/sellers/informations/banking#create') }
    end

    context 'PUT actions' do
      it { expect(put('dashboards/representantes/informacoes_pessoais/dados_bancarios/update')).to route_to('dashboards/sellers/informations/banking#update') }
    end
  end

  context 'DashboardsSellersFinanceMainController' do
    context 'GET actions' do
      it { expect(get('dashboards/representantes/financeiro')).to route_to('dashboards/sellers/finance/main#index') }
    end
  end

  context 'DashboardsSellersFinanceSalesController' do
    context 'GET actions' do
      it { expect(get('dashboards/representantes/financeiro/vendas')).to route_to('dashboards/sellers/finance/sales#index') }
    end
  end

  context 'DashboardsSellersFinanceReceiptsController' do
    context 'GET actions' do
      it { expect(get('dashboards/representantes/financeiro/recibos')).to route_to('dashboards/sellers/finance/receipts#index') }
    end

    context 'POST actions' do
      it { expect(post('dashboards/representantes/financeiro/recibos/recibo_pagamento_autonomo')).to route_to('dashboards/sellers/finance/receipts#generate_receipt') }
    end
  end

  context 'CamerasLoginsControllers' do
    context 'GET actions' do
      it { expect(get('cameras/logins')).to route_to('cameras/logins#index') }
      it { expect(get('cameras/logins/angels')).to route_to('cameras/logins#angels') }
      it { expect(get('cameras/logins/motoristas')).to route_to('cameras/logins#drivers') }
      it { expect(get('cameras/logins/driver_names')).to route_to('cameras/logins#driver_names') }
    end

    context 'POST actions' do
      it { expect(post('cameras/logins/validate_angels_access')).to route_to('cameras/logins#validate_angels_access') }
      it { expect(post('cameras/logins/validate_drivers_access')).to route_to('cameras/logins#validate_drivers_access') }
    end
  end

  context 'CamerasDashboardsControllers' do
    xit { expect(get('cameras/dashboards/passageiros')).to route_to('cameras/dashboards#passengers') }
  end

  context 'CamerasDashboardsDriversControllers' do
    it { expect(get('cameras/dashboards/motoristas')).to route_to('cameras/dashboards/drivers#index') }
    it { expect(get('cameras/dashboards/motoristas/login')).to route_to('cameras/dashboards/drivers#login') }
    it { expect(get('cameras/dashboards/motoristas/logout')).to route_to('cameras/dashboards/drivers#logout') }
    it { expect(get('cameras/dashboards/motoristas/qrcode')).to route_to('cameras/dashboards/drivers#qrcode') }
    it { expect(get('cameras/dashboards/motoristas/transmissao')).to route_to('cameras/dashboards/drivers#transmission' ) }
    it { expect(get('cameras/dashboards/angels')).to route_to('cameras/dashboards/angels#index') }
    it { expect(get('cameras/dashboards/angels/login')).to route_to('cameras/dashboards/angels#login') }
    it { expect(get('cameras/dashboards/angels/logout')).to route_to('cameras/dashboards/angels#logout') }
    it { expect(get('cameras/dashboards/angels/transmissao')).to route_to('cameras/dashboards/angels#transmission' ) }
    it { expect(get('cameras/dashboards/angels/motorista')).to route_to('cameras/dashboards/angels#driver' ) }
  end

  context 'TransmissionsControllers' do
    xit { expect(get('transmissao/driver-41235188701')).to route_to('transmission#index', driver_code: 'driver-41235188701') }
  end
end
