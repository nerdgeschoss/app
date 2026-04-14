# frozen_string_literal: true

class InventoriesController < ApplicationController
  before_action :authenticate_user!

  def new
    @inventory = authorize User.find(params[:user_id]).inventories.new(received_at: Time.zone.now)
    render Views::Inventories::New.new(inventory: @inventory), layout: false
  end

  def create
    @inventory = authorize Inventory.new(permitted_attributes(Inventory))
    @inventory.save!
    ui.navigate_to user_path(@inventory.user)
  end

  def edit
    @inventory = authorize Inventory.find(params[:id])
    render Views::Inventories::Edit.new(inventory: @inventory), layout: false
  end

  def update
    @inventory = authorize Inventory.find(params[:id])
    @inventory.update!(permitted_attributes(Inventory))
    ui.navigate_to user_path(@inventory.user)
  end

  def destroy
    @inventory = authorize Inventory.find(params[:id])
    @inventory.destroy!
    ui.navigate_to user_path(@inventory.user)
  end
end
