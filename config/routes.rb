# frozen_string_literal: true

Rails.application.routes.draw do
  root 'panels#index'
  post 'check_credentials', to: 'panels#check_credentials'

  scope module: 'customer_panel', path: 'cliente', as: 'customer_panel' do
    get 'main'
    get 'login'
    get 'logout'
    get 'states'
    get 'cities'
  end

  scope module: 'employee_panel', path: 'gestao', as: 'employee_panel' do
    get 'main'
    get 'login'
    get 'logout'
  end
end
