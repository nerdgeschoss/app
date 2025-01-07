# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  mount MissionControl::Jobs::Engine, at: "/jobs"
  get "sitemaps/*path", to: "shimmer/sitemaps#show"
  get "offline", to: "pages#offline"
  resources :files, only: :show, controller: "shimmer/files"
  resource :manifest, only: :show

  scope "/(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :payslips
    resources :leaves
    resources :sprints
    resources :sprint_feedbacks
    resources :users do
      get :unpaid_vacation, on: :member
      resources :inventories, only: :new
    end
    resources :inventories, only: [:create, :destroy, :edit, :update, :destroy]
    namespace :feed do
      resources :leaves, only: :index
    end
    resources :daily_nerd_messages, only: [:create, :update]
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    get "confirm_login", to: "sessions#edit"
    post "confirm_login", to: "sessions#update"
    get "logout", to: "sessions#destroy"
    root "pages#home"
  end

  namespace :integration do
    post "flink", to: "flink#webhook"
  end
end
