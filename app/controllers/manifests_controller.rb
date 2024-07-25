# frozen_string_literal: true

class ManifestsController < ApplicationController
  include ViteRails::TagHelpers
  include ActionView::Helpers::AssetUrlHelper

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
          src: vite_asset_path("images/app-icon.png"),
          sizes: "144x144",
          type: "image/png",
          purpose: "any"
        },
        {
          src: vite_asset_path("images/app-icon.png"),
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
