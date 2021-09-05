# frozen_string_literal: true

Rails.application.routes.draw do
  resources :imports
  root 'imports#index'
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'users/contacts', to: 'users#contacts'
  get 'imports/:id/logs', to: 'imports#logs', as: "logs"
  resources :users, except: [:new]
end
