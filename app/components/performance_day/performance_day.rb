# frozen_string_literal: true

class Components::PerformanceDay < Components::Base
  include Phlex::Rails::Helpers::NumberWithPrecision

  prop :day, SprintFeedback::Day

  def view_template
    div(id: "performance-day-#{@day.id}", class: "performance-day") do
      render_header
      div(class: "performance-day__content") do
        render_time_entries
        render_daily_nerd
      end
    end
  end

  private

  def render_header
    header(class: "performance-day__header") do
      text(type: :"h4-bold") { I18n.l(@day.day, format: :weekday) }
      text(type: :"caption-primary-regular", color: "label-heading-secondary") do
        I18n.l(@day.day, format: :long)
      end
    end
  end

  def render_time_entries
    if @day.time_entries.any?
      render_time_entries_table
    else
      text { "No entries" }
    end
  end

  def render_time_entries_table
    ul(class: "performance-day__table") do
      render_table_head
      @day.time_entries.each { |entry| render_entry_row(entry) }
      render_table_footer
    end
  end

  def render_table_head
    li(class: "performance-day__row performance-day__table-head") do
      div(class: "performance-day__cell") { text(type: :"caption-primary-bold") { "Project" } }
      div(class: "performance-day__cell") { text(type: :"caption-primary-bold") { "Source" } }
      div(class: "performance-day__cell") { text(type: :"caption-primary-bold") { "Users" } }
      div(class: "performance-day__cell") { text(type: :"caption-primary-bold") { "Tracked" } }
      div(class: "performance-day__cell") { text(type: :"caption-primary-bold") { "Total" } }
    end
  end

  def render_entry_row(entry)
    task = entry.task_object

    li(class: "performance-day__row") do
      render_entry_details(entry, task)
      render_source_cell(task)
      render_users_cell(task)
      render_tracked_cell(entry, task)
      render_total_cell(task)
    end
  end

  def render_entry_details(entry, task)
    div(class: "performance-day__cell performance-day__entry-details") do
      div(class: "performance-day__entry-data") do
        if task&.repository.present?
          text(type: :"caption-secondary-regular", color: "label-heading-secondary") { task.repository }
        end
        text(type: :"caption-primary-bold") { entry.project&.name } if entry.project
        text(type: :"body-secondary-regular") { entry.task }
        if entry.notes.present?
          text(type: :"body-secondary-regular", color: "label-heading-secondary") { entry.notes }
        end
        if entry.start_at
          text(type: :"body-secondary-regular", color: "label-heading-secondary") do
            format_time_range(entry)
          end
        end
      end
      render_status_pill(task) if task
    end
  end

  def render_status_pill(task)
    status = task.status&.downcase
    return unless StatusPill::VALID_STATUSES.include?(status)

    render StatusPill.new(title: status, status:)
  end

  def render_source_cell(task)
    div(class: "performance-day__cell performance-day__source") do
      if task&.github_url.present?
        a(href: task.github_url, target: "_blank", rel: "noopener noreferrer") do
          icon(name: :github, size: 20)
        end
      end
    end
  end

  def render_users_cell(task)
    div(class: "performance-day__cell performance-day__users") do
      task&.users&.each do |user|
        render Tooltip.new(content: user.display_name || user.email) do
          render Avatar.new(
            display_name: user.display_name,
            avatar_url: user.avatar_image(size: 120),
            email: user.email
          )
        end
      end
    end
  end

  def render_tracked_cell(entry, task)
    div(class: "performance-day__cell performance-day__tracked performance-day__cell--justify-end") do
      if entry.hours.to_f > 0
        text(type: :"body-secondary-regular") { "#{number_with_precision(entry.hours, precision: 1)} hrs" }
        if task&.time_entries&.sum(&:hours).to_f&.positive?
          span(class: "performance-day__mobile-total") do
            span { "/" }
            text(type: :"body-bold") { "#{number_with_precision(task.time_entries.sum(&:hours), precision: 1)} hrs" }
          end
        end
      end
    end
  end

  def render_total_cell(task)
    div(class: "performance-day__cell performance-day__total performance-day__cell--justify-end") do
      if task&.time_entries&.sum(&:hours).to_f&.positive?
        text(type: :"body-secondary-regular") { "#{number_with_precision(task.time_entries.sum(&:hours), precision: 1)} hrs" }
      end
    end
  end

  def render_table_footer
    li(class: "performance-day__row performance-day__table-footer") do
      div(class: "performance-day__cell performance-day__entry-details") do
        text(type: :"caption-primary-bold") { "Total" }
      end
      div(class: "performance-day__cell performance-day__source")
      div(class: "performance-day__cell performance-day__users")
      div(class: "performance-day__cell performance-day__tracked performance-day__cell--justify-end") do
        text(type: :"caption-primary-bold") { "#{number_with_precision(@day.tracked_hours, precision: 1)} hrs" }
      end
      div(class: "performance-day__cell performance-day__total performance-day__cell--justify-end")
    end
  end

  def render_daily_nerd
    stack(size: 24) do
      render IconTitle.new(icon: "✍️", title: "Daily Nerd", color: "var(--icon-day-empty)")
      stack(size: 16) do
        if @day.has_daily_nerd_message?
          render TextBox.new(content: @day.daily_nerd_message&.message)
        else
          text { "No daily nerd" }
        end
      end
    end
  end

  def format_time_range(entry)
    return unless entry.start_at

    start_time = I18n.l(entry.start_at, format: :short)
    if entry.respond_to?(:end_at) && entry.end_at
      "#{start_time} – #{I18n.l(entry.end_at, format: :short)}"
    else
      start_time
    end
  end
end
