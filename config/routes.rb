# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  mount Sidekiq::Web => "/sidekiq" # move to admin once there is authentication
  get "sitemaps/*path", to: "shimmer/sitemaps#show"
  get "offline", to: "pages#offline"
  resources :files, only: :show, controller: "shimmer/files"
  resource :manifest, only: :show

  scope "/(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users
    resources :payslips
    resources :leaves
    resources :sprints
    resources :sprint_feedbacks
    resources :users do
      get :unpaid_vacation, on: :member
    end
    namespace :feed do
      resources :leaves, only: :index
    end
    root "pages#home"
  end
end
