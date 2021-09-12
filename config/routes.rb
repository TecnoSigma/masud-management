# frozen_string_literal: true

Rails.application.routes.draw do
  get 'painel_do_cliente/login', to: 'customer_panel#login'
end
