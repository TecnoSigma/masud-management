# frozen_string_literal: true

Rails.application.routes.draw do
  post 'check_credentials', to: 'panels#check_credentials'

  scope module: 'customer_panel', path: 'painel_do_cliente', as: 'customer_panel' do
    get 'main'
    get 'login'
    get 'states'
    get 'cities'
  end

  scope module: 'employee_panel', path: 'painel_administrativo', as: 'employee_panel' do
    get 'main'
    get 'login'
  end
end
