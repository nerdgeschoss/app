# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  mount MissionControl::Jobs::Engine, at: "/jobs"
  post "/graphql", to: "graphql#execute"
  get "sitemaps/*path", to: "shimmer/sitemaps#show"
  resources :files, only: :show, controller: "shimmer/files"
  resource :manifest, only: :show

  scope "/(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :payslips
    resources :leaves do
      get "team_overview/:team_hash", action: :team_overview, as: :team_overview, on: :collection
    end
    resources :sprints
    resources :sprint_feedbacks do
      get "edit_retro", on: :member
      post "update_retro", on: :member
    end
    resources :users do
      get :unpaid_vacation, on: :member
      resources :inventories, only: :new
    end
    resources :inventories, only: [:create, :destroy, :edit, :update, :destroy]
    namespace :feed do
      resources :leaves, only: :index
    end
    resources :daily_nerd_messages, only: [:create, :update]
    resources :projects, only: :index
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    get "confirm_login", to: "sessions#edit"
    post "confirm_login", to: "sessions#update"
    get "logout", to: "sessions#destroy"
    root "pages#home"
  end

  namespace :api do
    namespace :v1 do
      resources :projects, only: :update
      resources :users do
        get :emails, on: :collection
      end
    end
  end
end
