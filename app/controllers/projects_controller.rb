# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @filter = params[:filter].presence || "active"
    @current_sprint = Sprint.current.take
    @customer_name = params[:customer].presence
    @presentation_mode = params[:presentation_mode] == "true"
    @hide_financials = @presentation_mode || !policy(Project).financial_details?
    @projects = policy_scope(Project.alphabetical)
      .page(params[:page]).per(40)
    @projects = @projects.includes(:invoices) if !@hide_financials
    @projects = @projects.where(client_name: @customer_name) if @customer_name
    case @filter
    when "active"
      @projects = @projects.active.customers
    when "internal"
      @projects = @projects.active.internal
    when "archived"
      @projects = @projects.archived
    end
  end
end
