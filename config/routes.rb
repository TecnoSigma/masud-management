# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: 'customer_panel', path: 'painel_do_cliente', as: 'customer_panel' do
    get 'main'
    get 'login'
    post 'check_credentials'
  end
end
