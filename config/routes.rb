# frozen_string_literal: true

Rails.application.routes.draw do
  root 'panels#index'

  get 'esqueceu_sua_senha', to: 'panels#forgot_your_password'
  post 'check_credentials', to: 'panels#check_credentials'
  post 'send_password',     to: 'panels#send_password'
  patch 'update_password',  to: 'panels#update_password'

  get 'cliente/esqueceu_sua_senha', to: 'customer_panel#forgot_your_password'

  get 'gestao/esqueceu_sua_senha', to: 'employee_panel#forgot_your_password'

  get 'cliente/dashboard/trocar_senha', to: 'customer_panel#change_password'

  get 'gestao/dashboard/trocar_senha', to: 'employee_panel#change_password'

  scope module: 'customer_panel', path: 'cliente', as: 'customer_panel' do
    get 'main'
    get 'login'
    get 'logout'
    get 'states'
    get 'cities'

    get 'dashboard/index'
    get 'dashboard/escolta/lista',                   to: 'escort#list'
    get 'dashboard/escolta/novo',                    to: 'escort#new'
    get 'dashboard/escolta/:order_number',           to: 'escort#show', as: 'escort_show'
    post 'dashboard/escolta/create',                 to: 'escort#create'
    delete 'dashboard/escolta/cancel/:order_number', to: 'escort#cancel', as: 'escort_cancel'
  end

  scope module: 'employee_panel', path: 'gestao', as: 'employee_panel' do
    get 'login'
    get 'logout'
    get 'dashboard/index'

    scope module: 'administrator_panel', path: 'admin', as: 'administrator' do
      get 'dashboard/index'

      get 'dashboard/escoltas/:status',      to: 'dashboard/escorts#escorts', as: 'dashboard_escorts'
      get 'dashboard/escolta/:order_number', to: 'dashboard/escorts#show', as: 'dashboard_escort_show'

      get 'dashboard/clientes',     to: 'dashboard/customers#list'
      get 'dashboard/cliente/novo', to: 'dashboard/customers#new'
      get 'dashboard/cliente/:id',  to: 'dashboard/customers#show', as: 'dashboard_customer_show'
    end

    scope module: 'agent_panel', path: 'agente', as: 'agent' do
      get 'dashboard'
    end

    scope module: 'lecturer_panel', path: 'conferente', as: 'lecturer' do
      get 'dashboard'
    end

    scope module: 'operator_panel', path: 'operador', as: 'operator' do
      get 'dashboard'
    end
  end
end
