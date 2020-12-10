# frozen_string_literal: true

Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :comments, only: %i[create destroy show]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  resources :microposts, only: %i[create destroy show]
  resources :relationships, only: %i[create destroy]
  resources :reaction, only: %i[create destroy]
  resources :export_csv, only: %i[index]
  resources :notifications, only: %i[show update]

  devise_for :users,path: 'my', controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'sign_up', to: 'devise/registrations#new'
  end

  resources :users, only: %i[index show edit destroy update] do
    member do
      get :following, :followers
    end
  end
  mount ActionCable.server => '/cable'
end
