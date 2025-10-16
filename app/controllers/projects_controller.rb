# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @filter = params[:filter].presence || "active"
    @projects = policy_scope(Project.alphabetical)
      .page(params[:page]).per(40)
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
