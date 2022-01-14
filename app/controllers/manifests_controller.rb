# frozen_string_literal: true

class ManifestsController < ApplicationController
  def show
    render json: {
      id: "/",
      name: "nerdgeschoss",
      short_name: "nerdgeschoss",
      start_url: "/",
      theme_color: "#ffffff",
      display: "standalone",
      background_color: "#ffffff",
      icons: [
        {
          src: asset_path("app-icon.png"),
          sizes: "144x144",
          type: "image/png",
          purpose: "any"
        },
        {
          src: asset_path("app-icon.png"),
          sizes: "144x144",
          type: "image/png",
          purpose: "maskable"
        }
      ]
    }
  end

  private

  def helper_proxy
    ActionController::Base.helpers
  end

  delegate :asset_path, to: :helper_proxy
end
