# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  mount Sidekiq::Web => "/sidekiq" # move to admin once there is authentication
  get "sitemaps/*path", to: "shimmer/sitemaps#show"
  resources :files, only: :show, controller: "shimmer/files"

  scope "/(:locale)", locale: /en/ do
    root "pages#home"
  end
end
