require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount Heartcheck::App.new, at: '/monitoring'

  root 'home#index'

  get 'home/chart_data',               to: 'home#chart_data'
  get 'home/hire',                     to: 'home#hire'
  get 'home/contrato',                 to: 'home#contract'
  get 'home/representantes',           to: 'home#seller'
  get 'home/representantes/contratar', to: 'home#hire_seller'
  get 'home/representantes/contrato',  to: 'home#seller_contract'
  post 'home/representantes/create',   to: 'home#create_seller'

  get 'checkout/identificacao',                to: 'checkout#identification'
  get 'checkout/identificacao/assinante',      to: 'checkout#subscriber'
  get 'checkout/identificacao/novo_assinante', to: 'checkout#new_subscriber'
  get 'checkout/veiculos',                     to: 'checkout#vehicles'
  get 'checkout/resumo',                       to: 'checkout#resume'
  get 'checkout/subscriber_address',           to: 'checkout#subscriber_address'
  get 'checkout/check_seller',                 to: 'checkout#check_seller'
  get 'checkout/user_availability',            to: 'checkout#user_availability'
  get 'checkout/subscriber_ip',                to: 'checkout#subscriber_ip'
  get 'checkout/vehicle_model_list',           to: 'checkout#vehicle_model_list'
  get 'checkout/add_vehicles',                 to: 'checkout#add_vehicles'
  get 'checkout/pagamento',                    to: 'checkout#payment'
  get 'checkout/finalizacao',                  to: 'checkout#finalization'
  get 'checkout/remove_vehicles',              to: 'checkout#remove_vehicles'
  post 'checkout/subscriber_info',             to: 'checkout#subscriber_info'
  post 'checkout/process_payment',             to: 'checkout#process_payment'
  post 'checkout/find_subscriber_data',        to: 'checkout#find_subscriber_data'

  get 'login/assinantes',                         to: 'subscriber_logins#index'
  get 'login/assinantes/esqueci_minha_senha',     to: 'subscriber_logins#forgot_my_password'
  get 'login/representantes',                     to: 'seller_logins#index'
  get 'login/representantes/esqueci_minha_senha', to: 'seller_logins#forgot_my_password'
  post 'login/assinantes/validate_access',        to: 'subscriber_logins#validate_subscriber_access'
  post 'login/assinantes/send_password',          to: 'subscriber_logins#send_subscriber_password'
  post 'login/representantes/validate_access',    to: 'seller_logins#validate_seller_access'
  post 'login/representantes/send_password',      to: 'seller_logins#send_seller_password'

  get 'dashboards/assinantes',                  to: 'dashboards/subscribers/main#index'
  get 'dashboards/assinantes/logout',           to: 'dashboards/subscribers/main#logout'

  get 'dashboards/assinantes/angels/',          to: 'dashboards/subscribers/angels#index'
  get 'dashboards/assinantes/angels/adicionar', to: 'dashboards/subscribers/angels#insert'
  get 'dashboards/assinantes/angels/editar',    to: 'dashboards/subscribers/angels#edit'
  post 'dashboards/assinantes/angels/create',   to: 'dashboards/subscribers/angels#create'
  put 'dashboards/assinantes/angels/update',    to: 'dashboards/subscribers/angels#update'
  delete 'dashboards/assinantes/angels/remove', to: 'dashboards/subscribers/angels#remove'

  get 'dashboards/assinantes/chamados',                    to: 'dashboards/subscribers/tickets#index'
  get 'dashboards/assinantes/chamados/novo',               to: 'dashboards/subscribers/tickets#new'
  get 'dashboards/assinantes/chamados/:ticket_id',         to: 'dashboards/subscribers/tickets#show', as: 'show_ticket'
  get 'dashboards/assinantes/chamados/:ticket_id/editar',  to: 'dashboards/subscribers/tickets#edit', as: 'edit_ticket'
  post 'dashboards/assinantes/chamados/create',            to: 'dashboards/subscribers/tickets#create'
  post 'dashboards/assinantes/chamados/reopen/:ticket_id', to: 'dashboards/subscribers/tickets#reopen', as: 'reopen_ticket'

  get 'dashboards/assinantes/monitoramento', to: 'dashboards/subscribers/monitoring#index'

  get 'dashboards/assinantes/motoristas',                      to: 'dashboards/subscribers/drivers#index'
  get 'dashboards/assinantes/motoristas/adicionar',            to: 'dashboards/subscribers/drivers#insert'
  get 'dashboards/assinantes/motoristas/:driver_id/detalhes',  to: 'dashboards/subscribers/drivers#details', as: 'driver_details'
  get 'dashboards/assinantes/motoristas/:driver_id/editar',    to: 'dashboards/subscribers/drivers#edit', as: 'edit_driver'
  post 'dashboards/assinantes/motoristas/create',              to: 'dashboards/subscribers/drivers#create'
  put 'dashboards/assinantes/motoristas/update',               to: 'dashboards/subscribers/drivers#update'
  delete 'dashboards/assinantes/motoristas/:driver_id/remove', to: 'dashboards/subscribers/drivers#remove', as: 'remove_driver'

  get 'dashboards/assinantes/veiculos',                             to: 'dashboards/subscribers/vehicles#index'
  get 'dashboards/assinantes/veiculos/:vehicle_id/adicionar_fotos', to: 'dashboards/subscribers/vehicles#add_photos', as: 'add_vehicle_photos'
  get 'dashboards/assinantes/veiculos/:vehicle_id/detalhes',        to: 'dashboards/subscribers/vehicles#details', as: 'vehicle_details'
  post 'dashboards/assinantes/veiculos/upload_photos',              to: 'dashboards/subscribers/vehicles#upload_photos'

  get 'dashboards/assinantes/informacoes_pessoais',          to: 'dashboards/subscribers/informations/main#index'

  get 'dashboards/assinantes/informacoes_pessoais/cadastro',        to: 'dashboards/subscribers/informations/register#index'
  get 'dashboards/assinantes/informacoes_pessoais/cadastro/editar', to: 'dashboards/subscribers/informations/register#edit'
  put 'dashboards/assinantes/informacoes_pessoais/cadastro/update', to: 'dashboards/subscribers/informations/register#update'

  get 'dashboards/assinantes/informacoes_pessoais/documentos',          to: 'dashboards/subscribers/informations/documents#index'
  get 'dashboards/assinantes/informacoes_pessoais/documentos/contrato', to: 'dashboards/subscribers/informations/documents#contract'
  get 'dashboards/assinantes/informacoes_pessoais/documentos/distrato', to: 'dashboards/subscribers/informations/documents#distract'

  get 'dashboards/representantes',        to: 'dashboards/sellers/main#index'
  get 'dashboards/representantes/logout', to: 'dashboards/sellers/main#logout'

  get 'dashboards/representantes/informacoes_pessoais',                 to: 'dashboards/sellers/informations/main#index'
  get 'dashboards/representantes/informacoes_pessoais/cadastro',        to: 'dashboards/sellers/informations/register#index'
  get 'dashboards/representantes/informacoes_pessoais/cadastro/editar', to: 'dashboards/sellers/informations/register#edit'
  put 'dashboards/representantes/informacoes_pessoais/cadastro/update', to: 'dashboards/sellers/informations/register#update'

  get 'dashboards/representantes/informacoes_pessoais/dados_bancarios',           to: 'dashboards/sellers/informations/banking#index'
  get 'dashboards/representantes/informacoes_pessoais/dados_bancarios/editar',    to: 'dashboards/sellers/informations/banking#edit'
  get 'dashboards/representantes/informacoes_pessoais/dados_bancarios/adicionar', to: 'dashboards/sellers/informations/banking#insert'
  post 'dashboards/representantes/informacoes_pessoais/dados_bancarios/create',   to: 'dashboards/sellers/informations/banking#create'
  put 'dashboards/representantes/informacoes_pessoais/dados_bancarios/update',    to: 'dashboards/sellers/informations/banking#update'

  get 'dashboards/representantes/informacoes_pessoais/documentos',          to: 'dashboards/sellers/informations/documents#index'
  get 'dashboards/representantes/informacoes_pessoais/documentos/contrato', to: 'dashboards/sellers/informations/documents#contract'
  get 'dashboards/representantes/informacoes_pessoais/documentos/distrato', to: 'dashboards/sellers/informations/documents#distract'

  get 'dashboards/representantes/financeiro',        to: 'dashboards/sellers/finance/main#index'

  get 'dashboards/representantes/financeiro/vendas', to: 'dashboards/sellers/finance/sales#index'

  get 'dashboards/representantes/financeiro/recibos',                            to: 'dashboards/sellers/finance/receipts#index'
  post 'dashboards/representantes/financeiro/recibos/recibo_pagamento_autonomo', to: 'dashboards/sellers/finance/receipts#generate_receipt'

  get 'cameras/logins',                             to: 'cameras/logins#index'
  get 'cameras/logins/angels',                      to: 'cameras/logins#angels'
  get 'cameras/logins/motoristas',                  to: 'cameras/logins#drivers'
  get 'cameras/logins/driver_names',                to: 'cameras/logins#driver_names'
  post 'cameras/logins/validate_angels_access',     to: 'cameras/logins#validate_angels_access'
  post 'cameras/logins/validate_drivers_access',    to: 'cameras/logins#validate_drivers_access'

  get 'cameras/dashboards/passageiros', to: 'cameras/dashboards#passengers'

  get 'cameras/dashboards/motoristas',             to: 'cameras/dashboards/drivers#index'
  get 'cameras/dashboards/motoristas/login',       to: 'cameras/dashboards/drivers#login'
  get 'cameras/dashboards/motoristas/logout',      to: 'cameras/dashboards/drivers#logout'
  get 'cameras/dashboards/motoristas/qrcode',      to: 'cameras/dashboards/drivers#qrcode'
  get 'cameras/dashboards/motoristas/transmissao', to: 'cameras/dashboards/drivers#transmission'

  get 'cameras/dashboards/angels',             to: 'cameras/dashboards/angels#index'
  get 'cameras/dashboards/angels/login',       to: 'cameras/dashboards/angels#login'
  get 'cameras/dashboards/angels/logout',      to: 'cameras/dashboards/angels#logout'
  get 'cameras/dashboards/angels/transmissao', to: 'cameras/dashboards/angels#transmission'
  get 'cameras/dashboards/angels/motorista',      to: 'cameras/dashboards/angels#driver'
  #get 'transmissao/:driver_code', to: 'transmission#index'
end
