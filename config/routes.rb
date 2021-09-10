# frozen_string_literal: true

Rails.application.routes.draw do
  authenticate :user do
    mount Blazer::Engine, at: 'blazer'
  end
  
  devise_for :users
  root to: 'pages#about'
  resources :members
  resources :events

  get 'pages/about', to: 'pages#about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Some setup you must do manually if you haven't yet:

  #   Ensure you have overridden routes for generated controllers in your routes.rb.
  #   For example:

  #     Rails.application.routes.draw do
  #       devise_for :users, controllers: {
  #         sessions: 'users/sessions'
  #       }
  #     end
end
