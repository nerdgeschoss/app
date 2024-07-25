# frozen_string_literal: true

class InventoriesController < ApplicationController
  def new
    @inventory = authorize User.find(params[:user_id]).inventories.new received_at: Time.zone.now
  end

  def create
    @inventory = authorize Inventory.new permitted_attributes(Inventory)
    @inventory.save!
    ui.navigate_to @inventory.user
  end

  def edit
    @inventory = authorize Inventory.find params[:id]
  end

  def update
    @inventory = authorize Inventory.find params[:id]
    @inventory.update! permitted_attributes(Inventory)
    ui.navigate_to @inventory.user
  end

  def destroy
    @inventory = authorize Inventory.find params[:id]
    @inventory.destroy!
    ui.navigate_to @inventory.user
  end
end
