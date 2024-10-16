# frozen_string_literal: true

require "benchmark"

class TSXHandler
  class << self
    def render(path, assigns)
      id = Pathname.new(path).relative_path_from(Rails.root.join("app", "views")).to_s
      schema = PropSchema.new(path.sub(".tsx", ".props.rb"))
      schema_file_path = path.sub(".tsx", ".schema.ts")
      File.write(schema_file_path, schema.to_typescript)
      props = schema.serialize(assigns).deep_transform_keys { _1.to_s.camelize(:lower) }
      response = nil
      time = Benchmark.realtime do
        response = HTTParty.post("http://localhost:4000/render", body: {path:, props:, id:}.to_json)
      end
      puts "took #{(time * 1000).round(2)}ms to render"
      response.body
    end
  end

  def call(template, source)
    "TSXHandler.render('#{template.identifier}', assigns)"
  end
end

ActionView::Template.register_template_handler(:tsx, TSXHandler.new)

class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    @payslips = current_user.payslips.reverse_chronologic.page(0).per(6)
    @sprint = Sprint.current.take
    @upcoming_leaves = current_user.leaves.future.not_rejected.chronologic
    if @sprint
      sprint_feedback = current_user.sprint_feedbacks.find_or_create_by(sprint: @sprint)
      @daily_nerd_message = authorize DailyNerdMessage.find_by(created_at: Time.zone.today.all_day, sprint_feedback:) || sprint_feedback.daily_nerd_messages.build
    end
    @needs_retro = current_user.sprint_feedbacks.sprint_past.retro_missing.first
  end

  def offline
  end
end
