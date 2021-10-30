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
    get 'dashboard/escolta/:order_number',           to: 'escort#show',   as: 'escort_show'
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
      get 'dashboard/escolta/:order_number', to: 'dashboard/escorts#show',    as: 'dashboard_escort_show'

      get 'dashboard/clientes',              to: 'dashboard/customers#list'
      get 'dashboard/cliente/novo',          to: 'dashboard/customers#new'
      get 'dashboard/cliente/:id',           to: 'dashboard/customers#show',   as: 'dashboard_customer_show'
      get 'dashboard/cliente/:id/editar',    to: 'dashboard/customers#edit',   as: 'dashboard_customer_edit'
      post 'dashboard/cliente/create',       to: 'dashboard/customers#create'
      patch 'dashboard/cliente/update/:id',  to: 'dashboard/customers#update', as: 'dashboard_customer_update'
      delete 'dashboard/cliente/remove/:id', to: 'dashboard/customers#remove', as: 'dashboard_customer_remove'

      get 'dashboard/funcionarios',              to: 'dashboard/employees#list'
      get 'dashboard/funcionario/novo',          to: 'dashboard/employees#new'
      get 'dashboard/funcionario/:id',           to: 'dashboard/employees#show',   as: 'dashboard_employee_show'
      get 'dashboard/funcionario/:id/editar',    to: 'dashboard/employees#edit',   as: 'dashboard_employee_edit'
      post 'dashboard/funcionario/create',       to: 'dashboard/employees#create'
      patch 'dashboard/funcionario/update/:id',  to: 'dashboard/employees#update', as: 'dashboard_employee_update'
      delete 'dashboard/funcionario/remove/:id', to: 'dashboard/employees#remove', as: 'dashboard_employee_remove'

      get 'dashboard/equipamentos',              to: 'dashboard/tackles#list'
      get 'dashboard/equipamento/novo',          to: 'dashboard/tackles#new'
      get 'dashboard/equipamento/:id',           to: 'dashboard/tackles#show',   as: 'dashboard_tackle_show'
      get 'dashboard/equipamento/:id/editar',    to: 'dashboard/tackles#edit',   as: 'dashboard_tackle_edit'
      post 'dashboard/equipamento/create',       to: 'dashboard/tackles#create'
      patch 'dashboard/equipamento/update/:id',  to: 'dashboard/tackles#update', as: 'dashboard_tackle_update'
      delete 'dashboard/equipamento/remove/:id', to: 'dashboard/tackles#remove', as: 'dashboard_tackle_remove'

      get 'dashboard/arsenais/armas',              to: 'dashboard/arsenals/guns#list'
      get 'dashboard/arsenais/arma/novo',          to: 'dashboard/arsenals/guns#new'
      get 'dashboard/arsenais/arma/:id',           to: 'dashboard/arsenals/guns#show',   as: 'dashboard_gun_show'
      get 'dashboard/arsenais/arma/:id/editar',    to: 'dashboard/arsenals/guns#edit',   as: 'dashboard_gun_edit'
      post 'dashboard/arsenais/arma/create',       to: 'dashboard/arsenals/guns#create'
      delete 'dashboard/arsenais/arma/remove/:id', to: 'dashboard/arsenals/guns#remove', as: 'dashboard_gun_remove'
      patch 'dashboard/arsenais/arma/update/:id',  to: 'dashboard/arsenals/guns#update', as: 'dashboard_gun_update'

      get 'dashboard/arsenais/municao/novo',          to: 'dashboard/arsenals/munitions#new'
      get 'dashboard/arsenais/municoes',              to: 'dashboard/arsenals/munitions#list'
      get 'dashboard/arsenais/municao/:id/editar',    to: 'dashboard/arsenals/munitions#edit',   as: 'dashboard_munition_edit'
      post 'dashboard/arsenais/municao/create',       to: 'dashboard/arsenals/munitions#create'
      patch 'dashboard/arsenais/municao/update/:id',  to: 'dashboard/arsenals/munitions#update', as: 'dashboard_munition_update'
      delete 'dashboard/arsenais/municao/remove/:id', to: 'dashboard/arsenals/munitions#remove', as: 'dashboard_munition_remove'

      get 'dashboard/viatura/novo',          to: 'dashboard/vehicles#new'
      get 'dashboard/viaturas',              to: 'dashboard/vehicles#list'
      get 'dashboard/viatura/:id',           to: 'dashboard/vehicles#show',   as: 'dashboard_vehicle_show'
      get 'dashboard/viatura/:id/editar',    to: 'dashboard/vehicles#edit',   as: 'dashboard_vehicle_edit'
      post 'dashboard/viatura/create',       to: 'dashboard/vehicles#create'
      patch 'dashboard/viatura/update/:id',  to: 'dashboard/vehicles#update', as: 'dashboard_vehicle_update'
      delete 'dashboard/viatura/remove/:id', to: 'dashboard/vehicles#remove', as: 'dashboard_vehicle_remove'
    end

    scope module: 'agent_panel', path: 'agente', as: 'agent' do
      get 'dashboard'
    end

    scope module: 'lecturer_panel', path: 'conferente', as: 'lecturer' do
      get 'dashboard'
    end

    scope module: 'operator_panel', path: 'operador', as: 'operator' do
      get 'dashboard/index'
      get 'dashboard/gerenciamento/:order_number',          to: 'dashboard#order_management', as:  'dashboard_order_management'
      post 'dashboard/gerenciamento/mount_items_list',      to: 'dashboard#mount_items_list'
      post 'dashboard/gerenciamento/mount_team',            to: 'dashboard#mount_team'
      post 'dashboard/gerenciamento/refuse_team',           to: 'dashboard#refuse_team'
      patch 'dashboard/gerenciamento/:order_number/refuse', to: 'dashboard#refuse', as: 'dashboard_refuse'
    end
  end
end
